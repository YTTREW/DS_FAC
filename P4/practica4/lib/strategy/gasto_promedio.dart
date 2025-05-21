import '../factory/suscripcion.dart';
import 'estrategia_gasto.dart';
class GastoPromedioStrategy implements EstrategiaGasto {
  @override
  double calcular(List<Suscripcion> lista) {
    if (lista.isEmpty) return 0.0;
    double suma = 0.0;
    for (final s in lista) {
      suma += s.precio;
    }
    return suma / lista.length;
  }
}
