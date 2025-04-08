import 'package:email_filter_app/credentials.dart';
import 'package:email_filter_app/auth_target.dart';
import 'package:email_filter_app/filters/filter.dart';

class FilterChain {
  final List<Filter> _filters = [];
  AuthTarget? _target;

  void addFilter(Filter filter) {
    _filters.add(filter);
  }

  void setTarget(AuthTarget target) {
    _target = target;
  }

  void execute(Credentials credentials) {
    for (final filter in _filters) {
      filter.execute(credentials);
    }
    _target?.authenticate(credentials);
  }
}
