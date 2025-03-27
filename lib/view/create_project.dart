import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateProjectScreen extends StatefulWidget {
  // Se agrega el parámetro 'key' en el constructor
  const CreateProjectScreen({super.key});

  @override
  CreateProjectScreenState createState() => CreateProjectScreenState();
}

class CreateProjectScreenState extends State<CreateProjectScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _createProject() async {
    String nombre = _nombreController.text;
    String descripcion = _descripcionController.text;

    if (nombre.isEmpty || descripcion.isEmpty) {
      Fluttertoast.showToast(msg: "Por favor ingresa todos los campos.");
      return;
    }

    try {
      await _firestore.collection('proyectos').add({
        'nombre': nombre,
        'descripcion': descripcion,
        'fecha_creacion': Timestamp.now(),
        'estado':
            'Activo', // El estado puede ser: Activo, En Progreso, Finalizado
      });

      Fluttertoast.showToast(msg: "Proyecto creado exitosamente.");

      // Se agrega la comprobación de 'mounted' antes de usar el BuildContext
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error al crear el proyecto.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Crear Proyecto")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: 'Nombre del Proyecto'),
            ),
            TextField(
              controller: _descripcionController,
              decoration: InputDecoration(
                labelText: 'Descripción del Proyecto',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createProject,
              child: Text("Crear Proyecto"),
            ),
          ],
        ),
      ),
    );
  }
}
