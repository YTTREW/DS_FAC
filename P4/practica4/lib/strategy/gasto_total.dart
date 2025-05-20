import '../factory/suscripcion.dart';
import 'estrategia_gasto.dart';

class GastoTotalStrategy implements EstrategiaGasto {
  @override
  double calcular(List<Suscripcion> lista) {
    double total = 0.0;
    for (final suscripcion in lista) {
      total += suscripcion.precio;
    }
    return total;
  }
}
