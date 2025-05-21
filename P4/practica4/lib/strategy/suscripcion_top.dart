import '../factory/suscripcion.dart';
import 'estrategia_gasto.dart';

class TopSuscripcionStrategy implements EstrategiaGasto {
  @override
  double calcular(List<Suscripcion> lista) {
    if (lista.isEmpty) return 0.0;
    double max = lista[0].precio;
    for (var i = 1; i < lista.length; i++) {
      if (lista[i].precio > max) {
        max = lista[i].precio;
      }
    }
    return max;
  }
}
