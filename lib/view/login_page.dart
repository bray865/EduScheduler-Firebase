import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart'; // Importa flutter_hooks
import 'package:gestion/controller/auth_controller.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'register_page.dart';

class LoginPage extends HookWidget {
  // Extiende HookWidget en lugar de StatefulWidget
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);

    // Usamos hooks para manejar los controladores de texto
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () async {
                // Realizamos el login
                await authController.login(
                  emailController.text,
                  passwordController.text,
                );

                // Verificamos si el usuario está autenticado
                if (authController.user != null) {
                  // Usamos `useEffect` para manejar la navegación asincrónica
                  Future.delayed(Duration.zero, () {
                    // Usamos `mounted` para asegurar que el widget sigue en el árbol
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    }
                  });
                }
              },
              child: Text("Iniciar Sesión"),
            ),
            TextButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  ),
              child: Text("¿No tienes cuenta? Regístrate"),
            ),
          ],
        ),
      ),
    );
  }
}
