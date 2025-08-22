import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth;
  final Logger _logger;

  // Configuración de límites de seguridad
  static const Map<String, Map<String, dynamic>> _securityLimits = {
    'login': {'maxAttempts': 5, 'cooldown': Duration(minutes: 15)},
    'register': {'maxAttempts': 3, 'cooldown': Duration(minutes: 30)},
    'passwordReset': {'maxAttempts': 3, 'cooldown': Duration(minutes: 30)},
  };

  // Constructor
  AuthService({FirebaseAuth? auth, Logger? logger})
    : _auth = auth ?? FirebaseAuth.instance,
      _logger = logger ?? Logger();

  /// Registra un nuevo usuario con email y contraseña
  Future<User?> register(String email, String password) async {
    return _withCooldownProtection(
      operation: 'register',
      action: () async {
        final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        return userCredential.user;
      },
    );
  }

  /// Inicia sesión con email y contraseña
  Future<User?> login(String email, String password) async {
    return _withCooldownProtection(
      operation: 'login',
      action: () async {
        final userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        return userCredential.user;
      },
    );
  }

  /// Solicita un restablecimiento de contraseña
  Future<void> sendPasswordResetEmail(String email) async {
    return _withCooldownProtection(
      operation: 'passwordReset',
      action: () => _auth.sendPasswordResetEmail(email: email),
    );
  }

  /// Cierra la sesión actual
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      _logger.e('Error al cerrar sesión: $e');
      rethrow;
    }
  }

  /// Devuelve el usuario actual (null si no hay sesión)
  User? get currentUser => _auth.currentUser;

  // ============ Métodos de protección por cooldown ============

  /// Envuelve una operación con protección de cooldown
  Future<T> _withCooldownProtection<T>({
    required String operation,
    required Future<T> Function() action,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // Verificar si está en cooldown
    if (await _isInCooldown(prefs, operation)) {
      final remaining = await _getRemainingCooldown(prefs, operation);
      _logger.w('Intento de $operation durante cooldown');
      throw FirebaseAuthException(
        code: 'too-many-requests',
        message:
            'Demasiados intentos. Por favor espere ${remaining.inMinutes} minutos.',
      );
    }

    try {
      final result = await action();
      await _resetAttempts(prefs, operation);
      return result;
    } catch (e) {
      await _recordFailedAttempt(prefs, operation);
      _logger.e('Error en $operation: $e');
      rethrow;
    }
  }

  /// Verifica si la operación está en cooldown
  Future<bool> _isInCooldown(SharedPreferences prefs, String operation) async {
    final attempts = prefs.getInt('${operation}_attempts') ?? 0;
    final lastAttempt = prefs.getInt('${operation}_last_attempt') ?? 0;
    final limits = _securityLimits[operation]!;

    return attempts >= (limits['maxAttempts'] as int) &&
        DateTime.now().difference(
              DateTime.fromMillisecondsSinceEpoch(lastAttempt),
            ) <
            (limits['cooldown'] as Duration);
  }

  /// Obtiene el tiempo restante de cooldown
  Future<Duration> _getRemainingCooldown(
    SharedPreferences prefs,
    String operation,
  ) async {
    final lastAttempt = prefs.getInt('${operation}_last_attempt') ?? 0;
    final limits = _securityLimits[operation]!;

    final cooldownEnd = DateTime.fromMillisecondsSinceEpoch(
      lastAttempt,
    ).add(limits['cooldown'] as Duration);
    return cooldownEnd.difference(DateTime.now());
  }

  /// Registra un intento fallido
  Future<void> _recordFailedAttempt(
    SharedPreferences prefs,
    String operation,
  ) async {
    final attempts = (prefs.getInt('${operation}_attempts') ?? 0) + 1;
    await prefs.setInt('${operation}_attempts', attempts);
    await prefs.setInt(
      '${operation}_last_attempt',
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Reinicia el contador de intentos
  Future<void> _resetAttempts(SharedPreferences prefs, String operation) async {
    await prefs.setInt('${operation}_attempts', 0);
  }
}
