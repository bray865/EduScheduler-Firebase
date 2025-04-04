import 'package:flutter/material.dart';
import 'package:gestion/components/menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Calendar extends StatelessWidget {
  const Calendar({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalendarScreen(),
    );
  }
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  List<Map<String, dynamic>> _eventList = [];
  String? _selectedEventType;

  @override
  void initState() {
    super.initState();
    _loadEventsFromFirestore();
  }

  Future<void> _loadEventsFromFirestore() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('eventos').get();
    setState(() {
      _eventList =
          snapshot.docs.map((doc) {
            final data = doc.data();
            return {
              'nombre': data['nombre'] ?? '',
              'profesor': data['profesor'] ?? '',
              'tipo': data['tipo'] ?? '',
              'descripcion': data['descripcion'] ?? '',
              'fecha': DateTime.parse(data['fecha']),
              'hora': data['hora'] ?? '',
              'estado': data['estado'] ?? 'Activo', // Nuevo campo
            };
          }).toList();
    });
  }

  Future<void> _addEventManually() async {
    final nombreController = TextEditingController();
    final profesorController = TextEditingController();
    final tipoController = TextEditingController();
    final descripcionController = TextEditingController();
    DateTime? selectedFecha;
    TimeOfDay? selectedHora;

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Nuevo Evento",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: nombreController,
                    decoration: const InputDecoration(
                      labelText: "Nombre del Evento",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: profesorController,
                    decoration: const InputDecoration(
                      labelText: "Profesor Responsable",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: tipoController,
                    decoration: const InputDecoration(
                      labelText: "Tipo de Evento",
                      hintText: "Ej: Examen, Charla, Vacaciones...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: descripcionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: "Descripción",
                      hintText: "Detalles adicionales del evento",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) selectedFecha = picked;
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: const Text("Seleccionar Fecha"),
                  ),
                  const SizedBox(height: 5),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) selectedHora = picked;
                    },
                    icon: const Icon(Icons.access_time),
                    label: const Text("Seleccionar Hora"),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: const Text("Cancelar"),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (selectedFecha != null &&
                              selectedHora != null &&
                              nombreController.text.isNotEmpty &&
                              profesorController.text.isNotEmpty &&
                              tipoController.text.isNotEmpty) {
                            final horaFormateada = selectedHora!.format(
                              context,
                            );
                            final fechaCompleta = DateTime(
                              selectedFecha!.year,
                              selectedFecha!.month,
                              selectedFecha!.day,
                              selectedHora!.hour,
                              selectedHora!.minute,
                            );

                            await FirebaseFirestore.instance
                                .collection('eventos')
                                .add({
                                  'nombre': nombreController.text,
                                  'profesor': profesorController.text,
                                  'tipo': tipoController.text,
                                  'descripcion': descripcionController.text,
                                  'fecha': fechaCompleta.toIso8601String(),
                                  'hora': horaFormateada,
                                  'estado': 'Activo', // Nuevo campo
                                });

                            if (!mounted) return;

                            setState(() {
                              _eventList.add({
                                'nombre': nombreController.text,
                                'profesor': profesorController.text,
                                'tipo': tipoController.text,
                                'descripcion': descripcionController.text,
                                'fecha': fechaCompleta,
                                'hora': horaFormateada,
                                'estado': 'Activo', // Nuevo campo
                              });
                            });

                            // ignore: use_build_context_synchronously
                            Navigator.pop(dialogContext);
                          }
                        },
                        child: const Text("Guardar"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getEventColor(String tipo) {
    if (tipo.toLowerCase().contains('vacacion')) return Colors.green;
    if (tipo.toLowerCase().contains('no laborable')) return Colors.red;
    if (tipo.toLowerCase().contains('fest')) return Colors.orange;
    return Colors.blueAccent;
  }

  List<Map<String, dynamic>> _getFilteredEvents() {
    if (_selectedEventType == null) return _eventList;
    return _eventList
        .where(
          (e) => e['tipo'].toString().toLowerCase().contains(
            _selectedEventType!.toLowerCase(),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredEvents = _getFilteredEvents();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestión de Eventos"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      drawer: ResponsiveMenu(
        onItemSelected: (Widget selectedPage) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => selectedPage),
          );
        },
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: [
              ElevatedButton(
                onPressed: () => setState(() => _selectedEventType = null),
                child: const Text("Todos"),
              ),
              ...['Vacaciones', 'Día No Laborable', 'Evento', 'Festividad'].map(
                (tipo) => ElevatedButton(
                  onPressed: () => setState(() => _selectedEventType = tipo),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getEventColor(tipo),
                  ),
                  child: Text(tipo),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(
                  Colors.indigo.shade100,
                ),
                columns: const [
                  DataColumn(label: Text("Nombre")),
                  DataColumn(label: Text("Profesor")),
                  DataColumn(label: Text("Tipo")),
                  DataColumn(label: Text("Fecha")),
                  DataColumn(label: Text("Hora")),
                  DataColumn(label: Text("Estado")), // Nueva columna
                  DataColumn(label: Text("Descripción")), // Nueva columna
                ],
                rows:
                    filteredEvents.map((event) {
                      return DataRow(
                        cells: [
                          DataCell(Text(event['nombre'])),
                          DataCell(Text(event['profesor'])),
                          DataCell(
                            Text(
                              event['tipo'],
                              style: TextStyle(
                                color: _getEventColor(event['tipo']),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(event['fecha'].toString().split(' ')[0]),
                          ),
                          DataCell(Text(event['hora'])),
                          DataCell(Text(event['estado'])), // Nueva celda
                          DataCell(Text(event['descripcion'])), // Nueva celda
                        ],
                      );
                    }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: _addEventManually,
            icon: const Icon(Icons.add),
            label: const Text("Añadir Evento"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
