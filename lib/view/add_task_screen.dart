import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gestion/components/menu.dart';
import 'package:gestion/view/all_tasks_screen.dart';

class AddTaskScreen extends StatefulWidget {
  final String projectId;

  const AddTaskScreen({super.key, required this.projectId});

  @override
  AddTaskScreenState createState() => AddTaskScreenState();
}

class AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _fechaVencimientoController =
      TextEditingController();
  final TextEditingController _comentariosController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _estadoSeleccionado = 'Pendiente';
  List<String> estados = [
    'Pendiente',
    'En Progreso',
    'Completada',
    'En Espera',
  ];

  String _prioridadSeleccionada = 'Media';
  List<String> prioridades = ['Alta', 'Media', 'Baja'];

  String _categoriaSeleccionada = 'General';
  List<String> categorias = ['General', 'Urgente', 'Importante', 'Opcional'];

  String _asignadoSeleccionado = 'Martha';
  List<String> asignados = ['Martha', 'Oscar', 'Saul'];

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _fechaVencimientoController.dispose();
    _comentariosController.dispose();
    super.dispose();
  }

  Future<void> _addTask() async {
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
          .collection('proyectos')
          .doc(widget.projectId)
          .collection('tareas')
          .add({
            'nombre': _nombreController.text,
            'descripcion': _descripcionController.text,
            'estado': _estadoSeleccionado,
            'fechaVencimiento': _fechaVencimientoController.text,
            'asignadoA': _asignadoSeleccionado,
            'prioridad': _prioridadSeleccionada,
            'comentarios': _comentariosController.text,
            'categoria': _categoriaSeleccionada,
            'fechaCreacion': FieldValue.serverTimestamp(),
          });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Tarea agregada exitosamente.")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al agregar tarea.")),
        );
      }
    }
  }

  Future<void> _selectFechaVencimiento() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _fechaVencimientoController.text =
            "${pickedDate.toLocal()}".split(' ')[0];
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
        title: const Text("Agregar Tarea"),
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
                      labelText: 'Nombre de la Tarea',
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
                    onTap: _selectFechaVencimiento,
                    child: AbsorbPointer(
                      child: TextField(
                        controller: _fechaVencimientoController,
                        decoration: const InputDecoration(
                          labelText: 'Fecha de Vencimiento',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                      ),
                    ),
                  ),
                  _buildDropdown(
                    'Asignado A',
                    _asignadoSeleccionado,
                    asignados,
                    (value) => setState(() => _asignadoSeleccionado = value!),
                  ),
                  _buildDropdown(
                    'Estado',
                    _estadoSeleccionado,
                    estados,
                    (value) => setState(() => _estadoSeleccionado = value!),
                  ),
                  _buildDropdown(
                    'Prioridad',
                    _prioridadSeleccionada,
                    prioridades,
                    (value) => setState(() => _prioridadSeleccionada = value!),
                  ),
                  _buildDropdown(
                    'Categoría',
                    _categoriaSeleccionada,
                    categorias,
                    (value) => setState(() => _categoriaSeleccionada = value!),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: _addTask,
                    child: const Text(
                      "Agregar Tarea",
                      style: TextStyle(
                        color:
                            Colors
                                .white, // Aquí puedes cambiar el color del texto
                      ),
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
            MaterialPageRoute(builder: (context) => const AllTasksScreen()),
          );
        },
      ),
    );
  }
}
