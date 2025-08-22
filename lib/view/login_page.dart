import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gestion/controller/auth_controller.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'register_page.dart';

class LoginPage extends HookWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context, listen: true);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final formKey = useState(GlobalKey<FormState>());
    final isPasswordVisible = useState(false);

    useEffect(() {
      return () {
        emailController.dispose();
        passwordController.dispose();
      };
    }, const []);

    return Scaffold(
      backgroundColor: Colors.white,
      body:
          authController.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Row(
                children: [
                  _buildWelcomeSection(),
                  _buildLoginForm(
                    context,
                    formKey,
                    emailController,
                    passwordController,
                    isPasswordVisible,
                    authController,
                  ),
                ],
              ),
    );
  }

  Widget _buildWelcomeSection() {
    return Expanded(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/icon.png', width: 150, height: 150),
              const SizedBox(height: 20),
              const Text(
                '¡Bienvenido a la plataforma!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Nos alegra verte de nuevo.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Accede a tu cuenta para continuar y aprovechar todas nuestras funcionalidades.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(
    BuildContext context,
    ValueNotifier<GlobalKey<FormState>> formKey,
    TextEditingController emailController,
    TextEditingController passwordController,
    ValueNotifier<bool> isPasswordVisible,
    AuthController authController,
  ) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Form(
          key: formKey.value,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset('assets/logo.png', width: 170, height: 170),
                const SizedBox(height: 20),
                const Text(
                  'Iniciar Sesión',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 20),
                _buildEmailField(emailController),
                const SizedBox(height: 16),
                _buildPasswordField(passwordController, isPasswordVisible),
                if (authController.errorMessage != null)
                  _buildErrorMessage(authController.errorMessage!),
                const SizedBox(height: 25),
                _buildLoginButton(
                  context,
                  formKey.value,
                  emailController,
                  passwordController,
                  authController,
                ),
                const SizedBox(height: 16),
                _buildRegisterButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField(TextEditingController emailController) {
    return TextFormField(
      controller: emailController,
      decoration: InputDecoration(
        labelText: "Correo",
        prefixIcon: const Icon(Icons.email),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) => _validateEmail(value),
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildPasswordField(
    TextEditingController passwordController,
    ValueNotifier<bool> isPasswordVisible,
  ) {
    return TextFormField(
      controller: passwordController,
      obscureText: !isPasswordVisible.value,
      decoration: InputDecoration(
        labelText: "Contraseña",
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () => isPasswordVisible.value = !isPasswordVisible.value,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) => _validatePassword(value),
    );
  }

  Widget _buildErrorMessage(String message) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        message,
        style: const TextStyle(color: Colors.red),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildLoginButton(
    BuildContext context,
    GlobalKey<FormState> formKey,
    TextEditingController emailController,
    TextEditingController passwordController,
    AuthController authController,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: const Size(double.infinity, 50),
      ),
      onPressed:
          () => _handleLogin(
            context,
            formKey,
            emailController,
            passwordController,
            authController,
          ),
      child: const Text(
        'Iniciar Sesión',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return TextButton(
      onPressed:
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegisterPage()),
          ),
      child: const Text(
        '¿No tienes cuenta? Regístrate',
        style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu correo';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Ingresa un correo válido';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu contraseña';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  Future<void> _handleLogin(
    BuildContext context,
    GlobalKey<FormState> formKey,
    TextEditingController emailController,
    TextEditingController passwordController,
    AuthController authController,
  ) async {
    if (!formKey.currentState!.validate()) return;

    await authController.login(emailController.text, passwordController.text);

    if (authController.user != null && context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }
}
