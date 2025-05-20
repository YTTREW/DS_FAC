import 'package:flutter/material.dart';
import 'factory/suscripcion.dart';
import 'factory/suscripcion_factory.dart';
import 'strategy/estrategia_gasto.dart';
import 'strategy/gasto_mensual.dart';
import 'strategy/gasto_total.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestor de Suscripciones',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Mis Suscripciones'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Suscripcion> suscripciones = [];
  bool mostrarFormulario = false;
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();

  void agregarDesdeFormulario() {
    final nombre = _nombreController.text.trim();
    final precio = double.tryParse(_precioController.text.trim()) ?? 0;

    if (nombre.isNotEmpty && precio > 0) {
      final nueva = SuscripcionFactory.desdeFormulario(
        nombre: nombre,
        precio: precio,
        tipo: 'mensual',
      );
      setState(() {
        suscripciones.add(nueva);
        mostrarFormulario = false;
        _nombreController.clear();
        _precioController.clear();
      });
    }
  }

  void editarSuscripcion(int index) {
    final suscripcion = suscripciones[index];
    final TextEditingController editarNombreController =
    TextEditingController(text: suscripcion.nombre);
    final TextEditingController editarPrecioController =
    TextEditingController(text: suscripcion.precio.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar suscripción'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: editarNombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: editarPrecioController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Precio'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final nuevoNombre = editarNombreController.text.trim();
              final nuevoPrecio = double.tryParse(editarPrecioController.text.trim()) ?? 0;

              if (nuevoNombre.isNotEmpty && nuevoPrecio > 0) {
                setState(() {
                  suscripciones[index] = Suscripcion(
                    id: suscripcion.id,
                    nombre: nuevoNombre,
                    precio: nuevoPrecio,
                    tipo: suscripcion.tipo,
                    fechaInicio: suscripcion.fechaInicio,
                  );
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  double calcularGasto(EstrategiaGasto estrategia) {
    return estrategia.calcular(suscripciones);
  }

  Map<String, double> gastoPorSuscripcion() {
    Map<String, double> mapa = {};
    for (var s in suscripciones) {
      mapa[s.nombre] = (mapa[s.nombre] ?? 0) + s.precio;
    }
    return mapa;
  }

  @override
  Widget build(BuildContext context) {
    final gastoMensual = calcularGasto(GastoMensualStrategy());
    final gastoTotal = calcularGasto(GastoTotalStrategy());
    final estadisticas = gastoPorSuscripcion();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text("Gasto mensual total: ${gastoMensual.toStringAsFixed(2)}\€"),
            const SizedBox(height: 8),
            if (mostrarFormulario)
              Column(
                children: [
                  TextField(
                    controller: _nombreController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre de la suscripción',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _precioController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Precio',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: agregarDesdeFormulario,
                    child: const Text("Agregar"),
                  ),
                ],
              ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: suscripciones.length,
                itemBuilder: (context, index) {
                  final s = suscripciones[index];
                  return ListTile(
                    title: Text(s.nombre),
                    subtitle: Text("${s.tipo} - ${s.precio.toStringAsFixed(2)}\€"),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'editar') {
                          editarSuscripcion(index);
                        } else if (value == 'eliminar') {
                          setState(() {
                            suscripciones.removeAt(index);
                          });
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: 'editar', child: Text('Editar')),
                        PopupMenuItem(value: 'eliminar', child: Text('Eliminar')),
                      ],
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            Text(
              "Estadísticas por suscripción:",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            ...estadisticas.entries.map((e) => Text("${e.key}: ${e.value.toStringAsFixed(2)}\€")),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            mostrarFormulario = !mostrarFormulario;
          });
        },
        icon: const Icon(Icons.add),
        label: const Text("Agregar suscripción"),
      ),
    );
  }
}
