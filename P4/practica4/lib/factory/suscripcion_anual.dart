import 'suscripcion.dart';

class SuscripcionAnual extends Suscripcion {
  SuscripcionAnual({
    int? id,
    required String nombre,
    required double precio,
    required DateTime fechaInicio,
  }) : super(id: id, nombre: nombre, precio: precio, fechaInicio: fechaInicio);

  @override
  String get tipo => 'anual';
}
