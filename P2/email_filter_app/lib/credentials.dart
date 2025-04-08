import 'package:flutter/material.dart';

class Credentials {
  String email;
  String password;

  Credentials({this.email = '', this.password = ''});
}

class CredentialsForm extends StatefulWidget {
  final Credentials credentials;

  const CredentialsForm({super.key, required this.credentials});

  @override
  State<CredentialsForm> createState() => _CredentialsFormState();
}

class _CredentialsFormState extends State<CredentialsForm> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: widget.credentials.email);
    passwordController = TextEditingController(
      text: widget.credentials.password,
    );

    // Escuchar cambios para actualizar el modelo
    emailController.addListener(() {
      widget.credentials.email = emailController.text;
    });

    passwordController.addListener(() {
      widget.credentials.password = passwordController.text;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'Correo electrónico',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: passwordController,
          decoration: const InputDecoration(
            labelText: 'Contraseña',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
        ),
      ],
    );
  }
}
