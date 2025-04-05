import 'package:email_filter_app/credentials.dart';
import 'package:email_filter_app/filters/filter.dart';

class PasswordUpperCaseFilter extends Filter {
  PasswordUpperCaseFilter() : super("Validar mayúscula en contraseña");

  @override
  void execute(Credentials credentials) {
    final password = credentials.password;
    if (password.isEmpty || !RegExp(r'[A-Z]').hasMatch(password)) {
      throw Exception(
        'Contraseña inválida: debe contener al menos una mayúscula',
      );
    }
  }
}
