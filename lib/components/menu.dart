import 'package:flutter/material.dart';
import 'package:gestion/view/calendar.dart';
import 'package:gestion/view/home_page.dart';
import 'package:gestion/view/upload_files.dart';
import 'package:gestion/controller/auth_controller.dart';
import 'package:gestion/view/login_page.dart'; // Importa la página de login
import 'package:provider/provider.dart';

class ResponsiveMenu extends StatefulWidget {
  final ValueChanged<Widget> onItemSelected;

  const ResponsiveMenu({super.key, required this.onItemSelected});

  @override
  ResponsiveMenuState createState() => ResponsiveMenuState();
}

class ResponsiveMenuState extends State<ResponsiveMenu> {
  bool _isExpanded = false; // Controla la expansión del menú inferior
  int _selectedIndex = -1; // Controla el ítem seleccionado

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context, listen: false);
    bool isMobile = MediaQuery.of(context).size.width < 600; // Detecta móviles

    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      elevation: 15,
      shadowColor: Colors.black45,
      child: Container(
        width: isMobile ? 55 : 180, // Barra lateral aún más estrecha
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey.shade900, Colors.black87],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 25),
            _avatar(),
            const SizedBox(height: 20),
            _menuItem(0, Icons.home_rounded, "Inicio", () {
              setState(() {
                _selectedIndex = 0; // Establece el ítem seleccionado
              });
              widget.onItemSelected(const HomePage());
            }, isMobile),
            _menuItem(1, Icons.calendar_today, "Calendario", () {
              setState(() {
                _selectedIndex = 1;
              });
              widget.onItemSelected(const Calendar());
            }, isMobile),
            _menuItem(2, Icons.cloud_upload_rounded, "Subir", () {
              setState(() {
                _selectedIndex = 2;
              });
              widget.onItemSelected(const SubidaArchivosPage());
            }, isMobile),
            _menuItem(3, Icons.settings_rounded, "Ajustes", () {
              setState(() {
                _selectedIndex = 3;
              });
            }, isMobile),
            const Spacer(), // Empuja el botón de logout hacia abajo
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Column(
                children: [
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    color: Colors.white70,
                    size: 30,
                  ),
                  if (_isExpanded)
                    Column(
                      children: [
                        _menuItem(
                          4,
                          Icons.exit_to_app_rounded,
                          "Salir",
                          () async {
                            await authController.logout(); // Cierra sesión
                            if (context.mounted) {
                              Navigator.pop(context); // Cierra el menú lateral
                            }
                            if (context.mounted) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                                (route) => false,
                              );
                            }
                          },
                          isMobile,
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _avatar() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white24,
        boxShadow: [
          BoxShadow(color: Colors.black38, blurRadius: 5, spreadRadius: 1),
        ],
      ),
      child: CircleAvatar(
        radius: 30, // Avatar un poco más grande
        backgroundColor: Colors.transparent,
        child: Icon(Icons.person, size: 30, color: Colors.white),
      ),
    );
  }

  Widget _menuItem(
    int index,
    IconData icon,
    String text,
    VoidCallback onTap,
    bool isMobile,
  ) {
    bool isSelected =
        index == _selectedIndex; // Verifica si el ítem está seleccionado

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color:
                isSelected
                    ? Colors.blueAccent
                    : Colors.transparent, // Fondo al seleccionar
            borderRadius: BorderRadius.circular(10),
            boxShadow:
                isSelected
                    ? [
                      BoxShadow(
                        color: Color.fromRGBO(0, 123, 255, 0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ]
                    : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  icon,
                  color: isSelected ? Colors.white : Colors.white70,
                  size: 30,
                ),
              ),
              if (!isMobile) // Muestra el texto solo en pantallas grandes
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
