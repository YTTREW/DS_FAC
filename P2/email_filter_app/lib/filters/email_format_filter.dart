import 'package:email_filter_app/credentials.dart';
import 'package:email_filter_app/filters/filter.dart';

class EmailFormatFilter extends Filter {
  EmailFormatFilter() : super("Validar el formato del correo electrónico");

  @override
  void execute(Credentials credentials) {
    final email = credentials.email;
    if (email.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      throw Exception('Correo inválido');
    }
  }
}
