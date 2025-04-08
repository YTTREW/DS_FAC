import '../credentials.dart';
import 'filter.dart';

class PasswordSpecialCharacterFilter extends Filter {
  // Lista de caracteres especiales permitidos
  static const String specialCharacters = "!@#\$%^&*(),.?\":{}|<>";

  PasswordSpecialCharacterFilter()
    : super("Validar caracteres especiales en contraseña");

  @override
  void execute(Credentials credentials) {
    final password = credentials.password;
    final regex = RegExp('.*[${RegExp.escape(specialCharacters)}].*');
    if (!regex.hasMatch(password)) {
      throw Exception(
        'Contraseña inválida: debe contener al menos un carácter especial',
      );
    }
  }
}
