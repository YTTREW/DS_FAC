import 'component.dart';
import 'abstract_decorator.dart';
import 'package:intl/intl.dart';


class CreationDateDecorator extends RecipeDecorator {
  final DateTime date;

  CreationDateDecorator(RecipeComponent component, this.date)
      : super(component);

  @override
  String getDescription() {
    final formattedDate = DateFormat('dd/MM/yyyy').format(date.toLocal());
    return "${super.getDescription()}\n📆 Fecha de creación: $formattedDate";
  }
}
