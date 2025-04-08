import 'package:email_filter_app/credentials.dart';
import 'package:email_filter_app/filters/filter.dart';

class PasswordLengthFilter extends Filter {
  static const int minLength = 5;
  static const int maxLength = 50;

  PasswordLengthFilter() : super("Validar longitud de contraseña");

  @override
  void execute(Credentials credentials) {
    final password = credentials.password;
    if (password.length < minLength || password.length > maxLength) {
      throw Exception('Contraseña inválida: longitud incorrecta');
    }
  }
}
