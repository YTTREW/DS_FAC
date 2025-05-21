abstract class Suscripcion {
  int? id;
  String nombre;
  double precio;
  DateTime fechaInicio;

  Suscripcion({
    this.id,
    required this.nombre,
    required this.precio,
    required this.fechaInicio,
  });

  String get tipo;
}
