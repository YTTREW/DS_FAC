import '../factory/suscripcion.dart';
import 'estrategia_gasto.dart';

class GastoMensualStrategy implements EstrategiaGasto {
  @override
  double calcular(List<Suscripcion> lista) {
    double total = 0.0;
    for (final s in lista) {
      if (s.tipo == 'mensual') {
        total += s.precio;
      }
    }
    return total;
  }
}
