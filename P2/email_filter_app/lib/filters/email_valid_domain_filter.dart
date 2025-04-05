import '../credentials.dart';
import 'filter.dart';

class EmailValidDomainFilter extends Filter {
  // Lista de sufijos de dominio permitidos
  static const List<String> validDomains = ['@gmail.com', '@hotmail.com'];

  // Constructor que pasa el nombre del filtro a la clase base
  EmailValidDomainFilter() : super("Validar dominio de correo");

  @override
  void execute(Credentials credentials) {
    final email = credentials.email;
    bool isValidDomain = false;

    // Verifica si el correo termina con uno de los sufijos válidos
    for (final domain in validDomains) {
      if (email.endsWith(domain)) {
        isValidDomain = true;
        break;
      }
    }

    if (!isValidDomain) {
      throw Exception('Correo inválido: dominio incorrecto');
    }
  }
}
