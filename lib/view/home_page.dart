import 'package:flutter/material.dart';
import 'package:gestion/components/menu.dart';
import 'package:gestion/controller/auth_controller.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      drawer: responsibeMenu(context), // 🔹 Agrega el menú como Drawer
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Bienvenido, ${authController.user?.email ?? 'Usuario'}",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
