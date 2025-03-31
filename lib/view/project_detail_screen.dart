import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final String studentId; // ID del proyecto
  final String taskId; // ID de la tarea

  const ProjectDetailsScreen({
    super.key,
    required this.studentId,
    required this.taskId,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalles del Proyecto"),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance
                .collection(
                  'estudiantes',
                ) // Asegúrate de que es la colección de proyectos
                .doc(studentId) // ID del proyecto
                .collection(
                  'proyectos',
                ) // Subcolección de tareas dentro de ese proyecto
                .doc(taskId) // ID de la tarea
                .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Proyecto no encontrado."));
          }

          var proyecto = snapshot.data!;
          var nombre = proyecto['nombre'] ?? 'Nombre no disponible';
          var descripcion =
              proyecto['descripcion'] ?? 'Descripción no disponible';
          var estado = proyecto['estado'] ?? 'Estado no disponible';
          var fechaInicio = proyecto['fechaInicio'];
          var fechaFin = proyecto['fechaFin'];
          var responsable =
              proyecto['responsable'] ?? 'Responsable no disponible';
          var tipo = proyecto['tipo'] ?? 'Tipo no definido';
          var fechaCreacion = proyecto['fechaCreacion'];

          if (fechaInicio is Timestamp) {
            fechaInicio = fechaInicio.toDate();
          } else {
            fechaInicio = null;
          }

          if (fechaFin is Timestamp) {
            fechaFin = fechaFin.toDate();
          } else {
            fechaFin = null;
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
                  // Título del proyecto
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

                  // Estado del proyecto
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color:
                            estado == "Activo"
                                ? Colors.green
                                : estado == "Inactivo"
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
                            estado == "Activo"
                                ? Colors.green
                                : estado == "Inactivo"
                                ? Colors.orange
                                : Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Descripción del proyecto
                  _buildDetailCard("Descripción", descripcion),
                  const SizedBox(height: 10),

                  // Fecha de inicio
                  if (fechaInicio != null)
                    _buildDetailCard(
                      "Fecha de Inicio",
                      fechaInicio.toLocal().toString(),
                    ),
                  const SizedBox(height: 10),

                  // Fecha de fin
                  if (fechaFin != null)
                    _buildDetailCard(
                      "Fecha de Fin",
                      fechaFin.toLocal().toString(),
                    ),
                  const SizedBox(height: 10),

                  // Responsable
                  _buildDetailCard("Responsable", responsable),
                  const SizedBox(height: 10),

                  // Tipo
                  _buildDetailCard("Tipo", tipo),
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
