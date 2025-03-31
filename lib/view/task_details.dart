import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskDetailsScreen extends StatelessWidget {
  final String projectId; // ID del proyecto
  final String taskId; // ID de la tarea

  const TaskDetailsScreen({
    super.key,
    required this.projectId,
    required this.taskId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalles de la Tarea"),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance
                .collection(
                  'proyectos',
                ) // Asegúrate de que es la colección de proyectos
                .doc(projectId) // ID del proyecto
                .collection(
                  'tareas',
                ) // Subcolección de tareas dentro de ese proyecto
                .doc(taskId) // ID de la tarea
                .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Tarea no encontrada."));
          }

          var tarea = snapshot.data!;
          var nombre = tarea['nombre'] ?? 'Nombre no disponible';
          var descripcion = tarea['descripcion'] ?? 'Descripción no disponible';
          var estado = tarea['estado'] ?? 'Estado no disponible';
          var fechaVencimiento = tarea['fechaVencimiento'];
          var asignadoA = tarea['asignadoA'] ?? 'Asignado a: no disponible';
          var prioridad = tarea['prioridad'] ?? 'Prioridad no definida';
          var comentarios = tarea['comentarios'] ?? 'Sin comentarios';
          var categoria = tarea['categoria'] ?? 'Categoría no definida';
          var fechaCreacion = tarea['fechaCreacion'];

          if (fechaVencimiento is Timestamp) {
            fechaVencimiento = fechaVencimiento.toDate();
          } else {
            fechaVencimiento = null;
          }

          if (fechaCreacion is Timestamp) {
            fechaCreacion = fechaCreacion.toDate();
          } else {
            fechaCreacion = null;
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título de la tarea
                  Card(
                    elevation: 5,
                    color: Colors.blue.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        nombre,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Estado de la tarea
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color:
                            estado == "Completada"
                                ? Colors.green
                                : estado == "Pendiente"
                                ? Colors.orange
                                : Colors.blue,
                        width: 2,
                      ),
                    ),
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "Estado: $estado",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color:
                            estado == "Completada"
                                ? Colors.green
                                : estado == "Pendiente"
                                ? Colors.orange
                                : Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Descripción de la tarea
                  _buildDetailCard("Descripción", descripcion),
                  const SizedBox(height: 10),

                  // Fecha de vencimiento
                  if (fechaVencimiento != null)
                    _buildDetailCard(
                      "Fecha de Vencimiento",
                      fechaVencimiento.toLocal().toString(),
                    ),
                  const SizedBox(height: 10),

                  // Asignado a
                  _buildDetailCard("Asignado a", asignadoA),
                  const SizedBox(height: 10),

                  // Prioridad
                  _buildDetailCard("Prioridad", prioridad),
                  const SizedBox(height: 10),

                  // Comentarios
                  _buildDetailCard("Comentarios", comentarios),
                  const SizedBox(height: 10),

                  // Categoría
                  _buildDetailCard("Categoría", categoria),
                  const SizedBox(height: 10),

                  // Fecha de creación
                  if (fechaCreacion != null)
                    _buildDetailCard(
                      "Fecha de Creación",
                      fechaCreacion.toLocal().toString(),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailCard(String title, String content) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$title: ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.blueAccent,
              ),
            ),
            Expanded(
              child: Text(
                content,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
