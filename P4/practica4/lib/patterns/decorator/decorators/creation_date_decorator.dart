import '../recipe_decorator.dart';
import 'package:intl/intl.dart';

class CreationDateDecorator extends RecipeDecorator {
  final DateTime date;

  CreationDateDecorator(super.component, this.date);

  @override
  String getDescription() {
    final formattedDate = DateFormat('dd/MM/yyyy').format(date.toLocal());
    return "${super.getDescription()}\n📆 Fecha de creación: $formattedDate";
  }
}
