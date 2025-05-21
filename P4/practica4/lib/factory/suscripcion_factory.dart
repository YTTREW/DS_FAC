import 'suscripcion.dart';
import 'suscripcion_mensual.dart';
import 'suscripcion_anual.dart';

class SuscripcionFactory {
  static Suscripcion desdeFormulario({
    required String nombre,
    required double precio,
    required String tipo,
  }) {
    final now = DateTime.now();
    if (tipo.toLowerCase() == 'mensual') {
      return SuscripcionMensual(nombre: nombre, precio: precio, fechaInicio: now);
    } else if (tipo.toLowerCase() == 'anual') {
      return SuscripcionAnual(nombre: nombre, precio: precio, fechaInicio: now);
    } else {
      throw ArgumentError('Tipo no soportado: $tipo');
    }
  }
}
