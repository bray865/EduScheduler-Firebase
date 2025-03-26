import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: CalendarScreen());
  }
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, String> _events = {};

  @override
  void initState() {
    super.initState();
    _loadEventsFromFirestore();
  }

  // Cargar eventos desde Firestore
  Future<void> _loadEventsFromFirestore() async {
    FirebaseFirestore.instance.collection('eventos').get().then((snapshot) {
      setState(() {
        _events = {
          for (var doc in snapshot.docs)
            DateTime.parse(doc['fecha'] as String): doc['tipo'] as String,
        };
      });
    });
  }

  // Agregar un evento a Firestore y al estado
  void _addEvent(String eventType) {
    FirebaseFirestore.instance.collection('eventos').add({
      'fecha': _selectedDay.toIso8601String(),
      'tipo': eventType,
    });
    setState(() {
      _events[_selectedDay] = eventType;
    });
  }

  // Método para obtener el color del día según el evento
  Color _getEventColor(String eventType) {
    switch (eventType) {
      case 'Vacaciones':
        return Colors.green; // Color para vacaciones
      case 'Día No Laborable':
        return Colors.red; // Color para días no laborables
      case 'Evento':
        return Colors.blue; // Color para eventos
      case 'Festividad':
        return Colors.orange; // Color para festividades
      default:
        return Colors.transparent; // Sin color si no hay evento
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Calendario')),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: DateTime.now(),
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
              });
            },
            // Resaltar días con eventos
            eventLoader: (day) {
              // Si hay un evento en este día, devuelvo el tipo de evento
              return _events[day] != null ? [_events[day]!] : [];
            },
            // Estilo del calendario con colores según el evento
            // Estilo del calendario con colores según el evento
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                // Si hay eventos, dibujamos un marcador de color
                if (events.isNotEmpty) {
                  // Verificamos que el primer evento sea un String
                  String eventType =
                      events.first is String ? events.first as String : '';

                  // Si es un tipo válido, dibujamos el marcador
                  if (eventType.isNotEmpty) {
                    return Positioned(
                      bottom: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: _getEventColor(
                            eventType,
                          ), // Obtener el color del evento
                          shape: BoxShape.circle,
                        ),
                        width: 8,
                        height: 8,
                      ),
                    );
                  }
                }
                return SizedBox.shrink(); // No mostrar nada si no hay evento o el evento es inválido
              },
            ),
          ),
          ElevatedButton(
            onPressed: () => _addEvent("Día No Laborable"),
            child: const Text("Marcar No Laborable"),
          ),
          ElevatedButton(
            onPressed: () => _addEvent("Vacaciones"),
            child: const Text("Marcar Vacaciones"),
          ),
          ElevatedButton(
            onPressed: () => _addEvent("Evento"),
            child: const Text("Marcar Evento"),
          ),
          ElevatedButton(
            onPressed: () => _addEvent("Festividad"),
            child: const Text("Marcar Festividad"),
          ),
        ],
      ),
    );
  }
}
