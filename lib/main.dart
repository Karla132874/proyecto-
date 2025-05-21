import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'pagina_resultado.dart';

void main() {
  runApp(const EvaluadorCVApp());
}

class EvaluadorCVApp extends StatelessWidget {
  const EvaluadorCVApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Evaluador de CV',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
        ),
      ),
      home: const PaginaInicioCV(),
    );
  }
}

class PaginaInicioCV extends StatefulWidget {
  const PaginaInicioCV({super.key});

  @override
  _PaginaInicioCVState createState() => _PaginaInicioCVState();
}

class _PaginaInicioCVState extends State<PaginaInicioCV> {
  PlatformFile? archivoSeleccionado;
  bool _isLoading = false;

  Future<void> seleccionarArchivo() async {
    final resultado = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg'],
    );
    if (resultado != null) {
      setState(() {
        archivoSeleccionado = resultado.files.single;
      });
    }
  }

  void limpiarArchivo() {
    setState(() {
      archivoSeleccionado = null;
    });
  }

  Future<void> evaluarArchivo() async {
    if (archivoSeleccionado == null || archivoSeleccionado!.path == null) {
      return;
    }

    setState(() => _isLoading = true);

    var uri = Uri.parse("http://192.168.8.64:8000/subir-cv/");
    var solicitud = http.MultipartRequest('POST', uri);
    solicitud.files.add(
      await http.MultipartFile.fromPath(
        'file',
        archivoSeleccionado!.path!,
        contentType: MediaType(
          archivoSeleccionado!.extension == 'pdf' ? 'application' : 'image',
          archivoSeleccionado!.extension!,
        ),
      ),
    );

    try {
      var respuesta = await solicitud.send();
      var contenido = await respuesta.stream.bytesToString();
      setState(() => _isLoading = false);

      if (respuesta.statusCode == 200) {
        var datos = json.decode(contenido);

        
        final area = datos['area'] as String? ?? 'Área no disponible';
        final recomendaciones = datos['recomendaciones'] as String? ?? '';

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaginaResultado(
              area: area,
              recomendaciones: recomendaciones,
            ),
          ),
        );
      } else {
        mostrarError("Error al procesar el archivo.");
      }
    } catch (e) {
      setState(() => _isLoading = false);
      mostrarError("Error de conexión o formato no legible.");
    }
  }

  void mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pastel = const Color(0xFF73AA9C);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.description_outlined, color: Colors.black),
            SizedBox(width: 10),
            Text('Evaluador de CV'),
          ],
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(24, 30, 24, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Sube tu currículum en PDF o imagen y recibe sugerencias personalizadas para mejorarlo.',
                    style: TextStyle(
                      fontSize: 25,
                      color: Color(0xFF616161), 
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: seleccionarArchivo,
                    child: Container(
                      height: 180,
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: pastel,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.07),
                            offset: const Offset(0, 3),
                            blurRadius: 7,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.upload_file,
                              size: 60,
                              color:
                                  archivoSeleccionado == null ? Colors.white : Colors.white,
                            ),
                            const SizedBox(height: 14),
                            Text(
                              archivoSeleccionado == null
                                  ? 'Haz clic para subir tu CV (PDF o imagen)'
                                  : 'Seleccionado: ${archivoSeleccionado!.name}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: archivoSeleccionado == null
                                    ? Colors.white
                                    : Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (archivoSeleccionado != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: evaluarArchivo,
                          icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                          label: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Text("Evaluar CV", style: TextStyle(color: Colors.white)),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: limpiarArchivo,
                          icon: const Icon(Icons.delete_outline, color: Colors.white),
                          label: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Text("Eliminar", style: TextStyle(color: Colors.white)),
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          
          if (_isLoading)
            Container(
              color: Colors.black38,
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
