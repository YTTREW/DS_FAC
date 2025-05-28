import 'component.dart';
import 'abstract_decorator.dart';

class CreationDateDecorator extends RecipeDecorator {
  final DateTime date;

  CreationDateDecorator(RecipeComponent component, this.date)
      : super(component);

  @override
  String getDescription() {
    return "${super.getDescription()} 📆 ${date.toLocal().toString().split(' ')[0]}";
  }
}
