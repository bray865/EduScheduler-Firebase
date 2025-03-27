import 'package:flutter/material.dart';
import 'package:gestion/components/menu.dart'; // Asegúrate de que este archivo contiene ResponsiveMenu
import 'package:gestion/controller/auth_controller.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      drawer: ResponsiveMenu(
        onItemSelected: (Widget selectedPage) {
          // Aquí puedes actualizar el contenido de la pantalla principal
          // Lógica para mostrar el contenido seleccionado
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => selectedPage),
          );
        },
      ), // ✅ Ahora pasamos la función de callback
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Bienvenido, ${authController.user?.email ?? 'Usuario'}",
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
