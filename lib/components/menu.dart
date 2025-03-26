import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: responsibeMenu(context));
  }
}

Widget responsibeMenu(BuildContext context) {
  final SidebarXController controller = SidebarXController(selectedIndex: 0);

  return Row(
    children: [
      SidebarX(
        controller: controller,
        theme: SidebarXTheme(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade900,
            borderRadius: BorderRadius.circular(10),
          ),
          hoverColor: Colors.blueGrey.shade700,
          textStyle: const TextStyle(color: Colors.white),
          selectedTextStyle: const TextStyle(color: Colors.amber),
          itemTextPadding: const EdgeInsets.only(left: 10),
          selectedItemTextPadding: const EdgeInsets.only(left: 10),
          iconTheme: const IconThemeData(color: Colors.white, size: 20),
          selectedIconTheme: const IconThemeData(color: Colors.amber, size: 20),
        ),
        extendedTheme: SidebarXTheme(
          width: 200,
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade800,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        items: [
          SidebarXItem(icon: Icons.home, label: 'Inicio', onTap: () {}),
          SidebarXItem(
            icon: Icons.login,
            label: 'Login',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      Expanded(
        child: Container(
          color: Colors.white,
          child: const Center(child: Text('Contenido Principal')),
        ),
      ),
    ],
  );
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: const Center(child: Text('Página de Login')),
    );
  }
}
