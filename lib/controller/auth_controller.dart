import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gestion/service/auth_service.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  String? _errorMessage;
  bool _isLoading = false;

  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  Future<void> register(String email, String password) async {
    try {
      _setLoading(true);
      _errorMessage = null;
      _user = await _authService.register(email, password);
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getFriendlyErrorMessage(e);
    } catch (e) {
      _errorMessage = "Error desconocido durante el registro";
    } finally {
      _setLoading(false);
    }
  }

  Future<void> login(String email, String password) async {
    try {
      _setLoading(true);
      _errorMessage = null;
      _user = await _authService.login(email, password);
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getFriendlyErrorMessage(e);
    } catch (e) {
      _errorMessage = "Error desconocido durante el inicio de sesión";
    } finally {
      _setLoading(false);
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      _setLoading(true);
      _errorMessage = null;
      await _authService.sendPasswordResetEmail(email);
      _errorMessage = "Correo de restablecimiento enviado";
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getFriendlyErrorMessage(e);
    } catch (e) {
      _errorMessage = "Error al enviar correo de restablecimiento";
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    try {
      _setLoading(true);
      await _authService.logout();
      _user = null;
    } catch (e) {
      _errorMessage = "Error al cerrar sesión";
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  String _getFriendlyErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No se encontró una cuenta con este correo electrónico';
      case 'wrong-password':
        return 'Contraseña incorrecta';
      case 'too-many-requests':
        return 'Demasiados intentos. Por favor, inténtalo de nuevo más tarde';
      case 'email-already-in-use':
        return 'Este correo electrónico ya está registrado';
      case 'weak-password':
        return 'La contraseña es demasiado débil';
      case 'invalid-email':
        return 'Correo electrónico no válido';
      case 'operation-not-allowed':
        return 'Operación no permitida';
      default:
        return e.message ?? 'Ocurrió un error inesperado';
    }
  }
}
