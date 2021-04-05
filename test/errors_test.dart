import 'package:flutter_test/flutter_test.dart';
import 'package:routing_path/routing_path.dart';

void main() {
  group('UnregisteredRouteException', () {
    test('#toString', () {
      const route = '/path/to/somewhere';

      expect(
        const UnregisteredRouteException(route).toString(),
        'RouteNotFoundException($route)',
      );

      final arguments = RouteArguments({'some': 'arguments'});
      expect(
        UnregisteredRouteException(route, arguments).toString(),
        'RouteNotFoundException($route, arguments: $arguments)',
      );
    });
  });
}
