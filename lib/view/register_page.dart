import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gestion/controller/auth_controller.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';

class RegisterPage extends HookWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);

    // Usamos useTextEditingController para gestionar los controladores de texto
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    // Usamos un hook para manejar el estado de la navegación
    final navigate = useState(
      false,
    ); // Esta variable controla si debe navegarse o no

    // Este efecto solo cambia el estado de navegación, no debe hacer la navegación directamente
    useEffect(() {
      if (navigate.value) {
        // Solo navegamos si el estado de 'navigate' es true
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (authController.user != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          }
        });
      }
      return null; // No necesitamos limpiar nada
    }, [navigate.value]); // El efecto se ejecuta cuando 'navigate' cambie

    return Scaffold(
      appBar: AppBar(title: Text("Registro")),
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
                // Realizamos el registro
                await authController.register(
                  emailController.text,
                  passwordController.text,
                );

                // Actualizamos el estado para activar la navegación
                navigate.value = true;
              },
              child: Text("Registrarse"),
            ),
          ],
        ),
      ),
    );
  }
}
