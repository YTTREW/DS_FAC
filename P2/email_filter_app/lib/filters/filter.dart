import 'package:email_filter_app/credentials.dart';

abstract class Filter {
  String name;
  Filter(this.name);

  void execute(Credentials credentials);
}
