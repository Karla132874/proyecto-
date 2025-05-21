import 'package:flutter/material.dart';

class PaginaResultado extends StatelessWidget {
  final String area;
  final String recomendaciones;

  const PaginaResultado({
    super.key,
    required this.area,
    required this.recomendaciones,
  });

  @override
  Widget build(BuildContext context) {
    final pastel = const Color(0xFF73AA9C);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.description_outlined, color: Colors.black),
            SizedBox(width: 8),
            Text(
              'Resultado',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Área:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: pastel.withOpacity(0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                area,
                style: const TextStyle(fontSize: 18, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Recomendaciones:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: pastel.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    recomendaciones,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.4,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Evaluar Otro CV',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
