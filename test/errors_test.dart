import 'package:flutter_test/flutter_test.dart';
import 'package:routing_path/routing_path.dart';

void main() {
  test('given null route', () {
    expect(() => RouteNotFoundException(null), throwsAssertionError);
  });

  test('#toString', () {
    const route = '/path/to/somewhere';

    expect(
      const RouteNotFoundException(route).toString(),
      'RouteNotFoundException($route)',
    );

    final arguments = RouteArguments({'some': 'arguments'});
    expect(
      RouteNotFoundException(route, arguments).toString(),
      'RouteNotFoundException($route, arguments: $arguments)',
    );
  });
}
