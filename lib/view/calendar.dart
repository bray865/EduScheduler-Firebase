import 'package:flutter/material.dart';
import 'package:gestion/components/menu.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Calendar extends StatelessWidget {
  const Calendar({super.key});

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
  Map<DateTime, List<String>> _events = {};
  String? _selectedEventType; // Tipo de evento seleccionado para filtrar
  Set<DateTime> _markedDays =
      {}; // Días que tienen eventos del tipo seleccionado

  @override
  void initState() {
    super.initState();
    _loadEventsFromFirestore();
  }

  /// Carga los eventos desde Firestore y actualiza la UI
  Future<void> _loadEventsFromFirestore() async {
    FirebaseFirestore.instance.collection('eventos').get().then((snapshot) {
      setState(() {
        _events = {};
        for (var doc in snapshot.docs) {
          DateTime date = DateTime.parse(doc['fecha'] as String);
          String eventType = doc['tipo'] as String;
          if (_events[date] == null) {
            _events[date] = [];
          }
          _events[date]!.add(eventType);
        }
      });
    });
  }

  /// Agrega un nuevo evento y lo refleja en la UI
  Future<void> _addEvent(String eventType) async {
    await FirebaseFirestore.instance.collection('eventos').add({
      'fecha': _selectedDay.toIso8601String(),
      'tipo': eventType,
    });

    setState(() {
      if (_events[_selectedDay] == null) {
        _events[_selectedDay] = [];
      }
      _events[_selectedDay]!.add(eventType);
    });
  }

  /// Devuelve un color según el tipo de evento
  Color _getEventColor(String eventType) {
    switch (eventType) {
      case 'Vacaciones':
        return Colors.green;
      case 'Día No Laborable':
        return Colors.red;
      case 'Evento':
        return Colors.blue;
      case 'Festividad':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  /// Filtra y muestra solo los días que tienen eventos del tipo seleccionado
  List<DateTime> _getDaysWithSelectedEventType() {
    if (_selectedEventType == null) return _events.keys.toList();

    return _events.keys.where((date) {
      return _events[date]!.contains(_selectedEventType);
    }).toList();
  }

  /// Actualiza los días que tienen el tipo de evento seleccionado
  void _updateMarkedDays() {
    setState(() {
      if (_selectedEventType == null) {
        _markedDays.clear();
      } else {
        _markedDays =
            _events.keys.where((date) {
              return _events[date]!.contains(_selectedEventType);
            }).toSet();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestión de Calendario'"),
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
          TableCalendar(
            focusedDay: _selectedDay,
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
            eventLoader: (day) {
              return _events[day] ?? [];
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                if (events.isNotEmpty && _markedDays.contains(day)) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                        events.map((event) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _getEventColor(event as String),
                              shape: BoxShape.circle,
                            ),
                          );
                        }).toList(),
                  );
                }
                return const SizedBox.shrink();
              },
              selectedBuilder: (context, day, focusedDay) {
                return Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withAlpha(70),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedEventType = null;
                    _updateMarkedDays();
                  });
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                child: const Text("Todos"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedEventType = "Día No Laborable";
                    _updateMarkedDays();
                  });
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("No Laborable"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedEventType = "Vacaciones";
                    _updateMarkedDays();
                  });
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text("Vacaciones"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedEventType = "Evento";
                    _updateMarkedDays();
                  });
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text("Evento"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedEventType = "Festividad";
                    _updateMarkedDays();
                  });
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text("Festividad"),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _getDaysWithSelectedEventType().length,
              itemBuilder: (context, index) {
                DateTime date = _getDaysWithSelectedEventType()[index];
                return Card(
                  color: Colors.grey[300],
                  child: ListTile(
                    title: Text(
                      "${date.toLocal()}".split(
                        ' ',
                      )[0], // Mostrar solo la fecha
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          _events[date]!.map((event) {
                            return Text(
                              event,
                              style: TextStyle(
                                color: _getEventColor(event),
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
          Wrap(
            spacing: 10,
            children: [
              ElevatedButton(
                onPressed: () => _addEvent("Día No Laborable"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Añadir No Laborable"),
              ),
              ElevatedButton(
                onPressed: () => _addEvent("Vacaciones"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text("Añadir Vacaciones"),
              ),
              ElevatedButton(
                onPressed: () => _addEvent("Evento"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text("Añadir Evento"),
              ),
              ElevatedButton(
                onPressed: () => _addEvent("Festividad"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text("Añadir Festividad"),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
