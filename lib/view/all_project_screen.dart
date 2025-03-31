import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestion/view/project_detail_screen.dart';

class AllProjectScreen extends StatelessWidget {
  const AllProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todos los proyectos"),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collectionGroup('proyectos').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No hay proyectos registrados."));
          }

          var proyectos = snapshot.data!.docs;

          return ListView.builder(
            itemCount: proyectos.length,
            itemBuilder: (context, index) {
              var tarea = proyectos[index];
              var taskId = tarea.id;

              // Convertir el objeto a un Map<String, dynamic>
              var tareaData = tarea.data() as Map<String, dynamic>;

              // Acceder a los campos de forma segura
              var nombre = tareaData['nombre'] ?? "Sin nombre";
              var descripcion = tareaData['descripcion'] ?? "Sin descripción";
              var estado = tareaData['estado'] ?? "Pendiente";

              // Color de fondo blanco para todos los proyectos
              Color cardColor = Colors.white;

              return Card(
                elevation: 10,
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: cardColor, // Color de fondo blanco
                shadowColor: Colors.grey, // Sombra gris suave
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    nombre,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: const Color(0xFF616161), // Título en gris suave
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      descripcion,
                      style: TextStyle(
                        color: const Color(
                          0xFF757575,
                        ), // Subtítulo en gris claro
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color:
                              estado == "Completado"
                                  ? Colors.green
                                  : estado == "Pendiente"
                                  ? Colors.orange
                                  : Colors.blue,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          estado,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.visibility,
                          color: Colors.teal, // Color del ícono en teal
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ProjectDetailsScreen(
                                    taskId: taskId,
                                    studentId:
                                        'ESwt72jwwWE23NHH0txu', // Usé el ID de la tarea actual
                                  ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
