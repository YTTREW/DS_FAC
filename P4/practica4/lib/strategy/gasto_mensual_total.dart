// lib/strategy/gasto_mensual_total.dart
import '../factory/suscripcion.dart';
import 'estrategia_gasto.dart';

class GastoMensualTotalStrategy implements EstrategiaGasto {
  @override
  double calcular(List<Suscripcion> lista) {
    double total = 0.0;
    int num_meses = 12;
    for (final s in lista) {
      if (s.tipo == 'mensual') {
        total += s.precio;
      } else if (s.tipo == 'anual') {
        total += s.precio / num_meses;
      }
    }

    return total;
  }
}
