import 'package:flutter_test/flutter_test.dart';
import 'package:routing_path/routing_path.dart';

import 'utils.dart';

class _ConcreteRouteHandler extends PathRouteHandler {
  _ConcreteRouteHandler(String path) : super(path);

  final MockPathRouteHandler mock = MockPathRouteHandler();

  @override
  Future<T> open<T>(String path, [RouteArguments arguments]) =>
      mock.open(path, arguments);
}

void main() {
  _ConcreteRouteHandler route;

  setUp(() {
    route = _ConcreteRouteHandler('/path/:id/:name');
  });

  test('given null path', () {
    expect(() => _ConcreteRouteHandler(null), throwsAssertionError);
  });

  test('given a path', () {
    expect(route.pattern, isNotNull);
  });

  group('#canOpen', () {
    test('given valid paths', () {
      expect(route.canOpen('/path/123/my_route'), isTrue);
      expect(route.canOpen('/path/123/my_route/'), isTrue);
      expect(route.canOpen('path/123/my_route/'), isTrue);
    });

    test('given invalid paths', () {
      expect(route.canOpen('/path/123/my_route/somewhere'), isFalse);
      expect(route.canOpen('/path/:id/:name'), isFalse);
      expect(route.canOpen('/path/123'), isFalse);
      expect(route.canOpen('/path'), isFalse);
      expect(route.canOpen('/'), isFalse);
    });
  });

  group('#setPattern', () {
    test('given a null path', () {
      expect(() => route.setPattern(null), throwsAssertionError);
    });

    test('given a new path', () {
      final currentPattern = route.pattern;
      route.setPattern('/new/path');
      expect(route.pattern, isNot(currentPattern));
    });
  });

  group('#replaceMatches', () {
    group('given a valid path', () {
      const validPath = '/path/123/my_route';

      test('and null arguments', () {
        expect(
          route.replaceMatches(validPath, null),
          RouteArguments({'id': '123', 'name': 'my_route'}),
        );
      });

      test('and empty arguments', () {
        expect(
          route.replaceMatches(validPath, RouteArguments({})),
          RouteArguments({'id': '123', 'name': 'my_route'}),
        );
      });

      test('and populated arguments', () {
        final initialArguments = RouteArguments({'some_argument': 123});
        expect(
          route.replaceMatches(validPath, initialArguments),
          RouteArguments(
              {'id': '123', 'name': 'my_route', 'some_argument': 123}),
        );
      });

      test('and arguments with conflicting keys', () {
        final initialArguments =
            RouteArguments({'id': 999, 'name': 'initial name'});
        expect(
          route.replaceMatches(validPath, initialArguments),
          RouteArguments({'id': '123', 'name': 'my_route'}),
        );
      });
    });

    group('given an invalid path', () {
      const invalidPath = '/path';

      test('and null arguments', () {
        expect(
          route.replaceMatches(invalidPath, null),
          isNull,
        );
      });

      test('and arguments', () {
        final initialArguments = RouteArguments({'some': 'value'});
        expect(
          route.replaceMatches(invalidPath, initialArguments),
          same(initialArguments),
        );
      });
    });
  });
}
