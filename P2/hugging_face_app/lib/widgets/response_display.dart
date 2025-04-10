import 'package:flutter/material.dart';

class ResponseDisplay extends StatelessWidget {
  final String response;

  const ResponseDisplay({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: SingleChildScrollView(
          child: Text(
            response.isNotEmpty ? response : 'Aquí aparecerá la respuesta...',
            style: const TextStyle(fontSize: 16),
            textDirection: TextDirection.ltr,
          ),
        ),
      ),
    );
  }
}
