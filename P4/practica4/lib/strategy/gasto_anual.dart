import '../factory/suscripcion.dart';
import 'estrategia_gasto.dart';

class GastoAnualStrategy implements EstrategiaGasto {
  @override
  double calcular(List<Suscripcion> lista) {
    double total = 0.0;
    for (final s in lista) {
      if (s.tipo.toLowerCase() == 'anual') {
        total += s.precio;
      }
    }
    return total;
  }
}
