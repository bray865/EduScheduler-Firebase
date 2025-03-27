import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gestion/view/add_task_screen.dart';

class ProjectDetailScreen extends StatelessWidget {
  final String projectId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Constructor con 'const' y 'super.key' para el parámetro 'key'
  ProjectDetailScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detalles del Proyecto")),
      body: StreamBuilder(
        stream: _firestore.collection('proyectos').doc(projectId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var proyecto = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Nombre: ${proyecto['nombre']}",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Descripción: ${proyecto['descripcion']}"),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Estado: ${proyecto['estado']}"),
              ),
              Expanded(
                child: StreamBuilder(
                  stream:
                      _firestore
                          .collection('proyectos')
                          .doc(projectId)
                          .collection('tareas')
                          .snapshots(),
                  builder: (context, taskSnapshot) {
                    if (!taskSnapshot.hasData) {
                      return Center(child: Text("No hay tareas asignadas"));
                    }

                    var tareas = taskSnapshot.data!.docs;
                    return ListView.builder(
                      itemCount: tareas.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(tareas[index]['nombre']),
                          subtitle: Text("Estado: ${tareas[index]['estado']}"),
                        );
                      },
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddTaskScreen(projectId: projectId),
                    ),
                  );
                },
                child: Text("Agregar Tarea"),
              ),
            ],
          );
        },
      ),
    );
  }
}
