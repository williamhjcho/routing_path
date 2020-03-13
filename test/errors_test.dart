import 'package:flutter_test/flutter_test.dart';
import 'package:routing_path/routing_path.dart';
import 'package:routing_path/src/utils/path_matcher.dart';

void main() {
  group('UnregisteredRouteException', () {
    test('given null route', () {
      expect(() => UnregisteredRouteException(null), throwsAssertionError);
    });
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

  group('UnmatchedPathException', () {
    const path = '/path/:id/to/:name';
    final pattern = RegExp(defaultPathPattern);

    test('#toString', () {
      expect(
        UnmatchedPathException(path, pattern).toString(),
        'UnmatchedPathException($path, $pattern)',
      );
    });
  });
}
