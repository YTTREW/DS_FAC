import '../credentials.dart';
import 'filter.dart';

class EmailAlreadyUsedFilter extends Filter {
  // Lista simulada de emails registrados
  static final Set<String> _registeredEmails = {};

  EmailAlreadyUsedFilter()
    : super("Verificar si el correo ya ha sido registrado");

  @override
  void execute(Credentials credentials) {
    final email = credentials.email.trim().toLowerCase();

    if (_registeredEmails.contains(email)) {
      throw Exception("Correo inválido: ya ha sido registrado previamente");
    }

    // Si es válido y nuevo, lo añadimos a la base simulada
    _registeredEmails.add(email);
  }
}
