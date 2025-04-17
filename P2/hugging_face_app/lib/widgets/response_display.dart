import 'package:flutter/material.dart';

class ResponseDisplay extends StatelessWidget {
  final String response;
  final bool isLoading;

  const ResponseDisplay({
    super.key,
    required this.response,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity, // Asegura el ancho total
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                isLoading
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(height: 12),
                          Text(
                            'Esperando respuesta del modelo...',
                            style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    )
                    : SingleChildScrollView(
                      child: Text(
                        response.isNotEmpty
                            ? response
                            : 'Aquí aparecerá la respuesta...',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
          ),
        ),
      ),
    );
  }
}
