import 'package:flutter/material.dart';
import 'package:gestion/controller/auth_controller.dart';
import 'package:gestion/view/login_page.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart'; // Import necesario para inicializar Firebase
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Asegúrate de que Flutter está completamente inicializado.
  await Firebase.initializeApp(
    options:
        DefaultFirebaseOptions
            .currentPlatform, // Opciones de Firebase según la plataforma
  );
  runApp(
    const MyApp(),
  ); // Inicia la aplicación una vez que Firebase se ha inicializado.
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthController(), // Proveedor del AuthController
      child: MaterialApp(
        debugShowCheckedModeBanner:
            false, // Desactivar la bandera de depuración
        home: const LoginPage(), // Página de inicio de sesión
      ),
    );
  }
}
