class Suscripcion {
  int? id;
  String nombre;
  double precio;
  DateTime fechaInicio;
  String tipo;

  Suscripcion({
    this.id,
    required this.nombre,
    required this.precio,
    required this.fechaInicio,
    required this.tipo,
  });
}
