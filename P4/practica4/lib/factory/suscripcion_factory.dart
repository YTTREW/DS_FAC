import 'suscripcion.dart';

class SuscripcionFactory {
  static Suscripcion desdeFormulario({
    required String nombre,
    required double precio,
    required String tipo,
  }) {
    return Suscripcion(
      nombre: nombre,
      precio: precio,
      tipo: tipo,
      fechaInicio: DateTime.now(),
    );
  }
}
