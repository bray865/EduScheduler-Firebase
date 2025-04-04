import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gestion/components/menu.dart';
import 'package:gestion/view/all_project_screen.dart';

class AddProjectScreen extends StatefulWidget {
  final String studentId;

  const AddProjectScreen({super.key, required this.studentId});

  @override
  AddProjectScreenState createState() => AddProjectScreenState();
}

class AddProjectScreenState extends State<AddProjectScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _fechaInicioController = TextEditingController();
  final TextEditingController _fechaFinController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _estadoSeleccionado = 'Pendiente';
  List<String> estados = [
    'Pendiente',
    'En Progreso',
    'Completado',
    'Cancelado',
  ];

  String _tipoSeleccionado = 'Software';
  List<String> tipos = ['Software', 'Investigación', 'Diseño', 'Hardware'];

  String _responsableSeleccionado = 'Roberto';
  List<String> responsables = ['Mario', 'Roberto', 'Jesus'];

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _fechaInicioController.dispose();
    _fechaFinController.dispose();
    super.dispose();
  }

  Future<void> _addProject() async {
    if (_nombreController.text.isEmpty || _descripcionController.text.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Por favor ingresa todos los campos.")),
        );
      }
      return;
    }

    try {
      await _firestore
          .collection('estudiantes')
          .doc(widget.studentId)
          .collection('proyectos')
          .add({
            'nombre': _nombreController.text,
            'descripcion': _descripcionController.text,
            'estado': _estadoSeleccionado,
            'fechaInicio': _fechaInicioController.text,
            'fechaFin': _fechaFinController.text,
            'responsable': _responsableSeleccionado,
            'tipo': _tipoSeleccionado,
            'fechaCreacion': FieldValue.serverTimestamp(),
          });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Proyecto agregado exitosamente.")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al agregar proyecto.")),
        );
      }
    }
  }

  Future<void> _selectFechaInicio() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _fechaInicioController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _selectFechaFin() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _fechaFinController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.blue.shade50,
        ),
        value: value,
        onChanged: onChanged,
        items:
            items.map((String item) {
              return DropdownMenuItem<String>(value: item, child: Text(item));
            }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agregar Proyecto"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      drawer: ResponsiveMenu(
        onItemSelected: (Widget selectedPage) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => selectedPage),
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 10,
          shadowColor: Colors.blue.shade200,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _nombreController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del Proyecto',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _descripcionController,
                    decoration: const InputDecoration(
                      labelText: 'Descripción',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: _selectFechaInicio,
                    child: AbsorbPointer(
                      child: TextField(
                        controller: _fechaInicioController,
                        decoration: const InputDecoration(
                          labelText: 'Fecha de Inicio',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: _selectFechaFin,
                    child: AbsorbPointer(
                      child: TextField(
                        controller: _fechaFinController,
                        decoration: const InputDecoration(
                          labelText: 'Fecha de Fin',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                      ),
                    ),
                  ),
                  _buildDropdown(
                    'Responsable',
                    _responsableSeleccionado,
                    responsables,
                    (value) =>
                        setState(() => _responsableSeleccionado = value!),
                  ),
                  _buildDropdown(
                    'Estado',
                    _estadoSeleccionado,
                    estados,
                    (value) => setState(() => _estadoSeleccionado = value!),
                  ),
                  _buildDropdown(
                    'Tipo de Proyecto',
                    _tipoSeleccionado,
                    tipos,
                    (value) => setState(() => _tipoSeleccionado = value!),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: _addProject,
                    child: const Text(
                      "Agregar Proyecto",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.list, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AllProjectScreen()),
          );
        },
      ),
    );
  }
}
