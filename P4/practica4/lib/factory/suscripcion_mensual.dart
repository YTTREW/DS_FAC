import 'suscripcion.dart';

class SuscripcionMensual extends Suscripcion {
  SuscripcionMensual({
    int? id,
    required String nombre,
    required double precio,
    required DateTime fechaInicio,
  }) : super(id: id, nombre: nombre, precio: precio, fechaInicio: fechaInicio);

  @override
  String get tipo => 'mensual';
}
