import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Subida de Archivos Excel',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E52B1)),
        useMaterial3: true,
      ),
      home: const SubidaArchivosPage(),
    );
  }
}

class SubidaArchivosPage extends StatefulWidget {
  const SubidaArchivosPage({super.key});

  @override
  State<SubidaArchivosPage> createState() => _SubidaArchivosPageState();
}

class _SubidaArchivosPageState extends State<SubidaArchivosPage> {
  PlatformFile? _archivoSeleccionado;
  String? _errorArchivo;
  bool _cargando = false;

  Future<void> _seleccionarArchivo() async {
    setState(() => _cargando = true);
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (result != null) {
        setState(() {
          _archivoSeleccionado = result.files.first;
          _errorArchivo = null;
        });
      }
    } catch (e) {
      setState(() => _errorArchivo = 'Error al seleccionar el archivo: $e');
    }
    setState(() => _cargando = false);
  }

  void _subirArchivo() {
    if (_archivoSeleccionado != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Archivo seleccionado: ${_archivoSeleccionado!.name}'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona un archivo Excel.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          'Subida de Archivos Excel',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(Icons.upload_file, size: 60, color: Colors.blue),
                  const SizedBox(height: 10),
                  const Text(
                    'Subir Archivos Excel',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Solo se permiten archivos .xlsx o .xls',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _seleccionarArchivo,
                    icon: _cargando
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Icon(Icons.folder_open),
                    label: Text(_cargando ? 'Cargando...' : 'Seleccionar Archivo'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_archivoSeleccionado != null)
                    Text(
                      'Archivo: ${_archivoSeleccionado!.name}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  if (_errorArchivo != null)
                    Text(
                      _errorArchivo!,
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _subirArchivo,
                    icon: const Icon(Icons.cloud_upload),
                    label: const Text('Subir Archivo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}