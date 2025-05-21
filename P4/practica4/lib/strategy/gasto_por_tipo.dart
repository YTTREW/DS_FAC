import '../factory/suscripcion.dart';
import 'estrategia_gasto.dart';

class GastoPorTipoStrategy implements EstrategiaGasto {
  final String tipoSeleccionado;
  GastoPorTipoStrategy(this.tipoSeleccionado);

  @override
  double calcular(List<Suscripcion> lista) {
    double total = 0.0;
    for (final s in lista) {
      if (s.tipo.toLowerCase() == tipoSeleccionado.toLowerCase()) {
        total += s.precio;
      }
    }
    return total;
  }
}
