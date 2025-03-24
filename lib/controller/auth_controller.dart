import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gestion/service/auth_service.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService(); // Instancia del AuthService
  User? _user;

  User? get user => _user; // Obtener el usuario actual

  // Método para registrar un nuevo usuario
  Future<void> register(String email, String password) async {
    _user = await _authService.register(email, password);
    notifyListeners(); // Notificar a los oyentes para que se actualicen
  }

  // Método para iniciar sesión
  Future<void> login(String email, String password) async {
    _user = await _authService.login(email, password);
    notifyListeners(); // Notificar a los oyentes para que se actualicen
  }

  // Método para cerrar sesión
  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners(); // Notificar a los oyentes para que se actualicen
  }
}
