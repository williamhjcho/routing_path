import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:routing_path/routing_path.dart';

import 'utils.dart';

class _MockPathRouteHandler extends Mock implements PathRouteHandler {
  @override
  Future<T> openPath<T>(RouteArguments arguments);
}

class _ConcretePathRouteHandler extends PathRouteHandler {
  _ConcretePathRouteHandler(String path) : super(path);

  final _MockPathRouteHandler mock = _MockPathRouteHandler();

  @override
  Future<T> openPath<T>(RouteArguments arguments) =>
      mock.openPath<T>(arguments);
}

void main() {
  _ConcretePathRouteHandler route;

  setUp(() {
    route = _ConcretePathRouteHandler('/path/:id/:name');
  });

  test('given null path', () {
    expect(() => _ConcretePathRouteHandler(null), throwsAssertionError);
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

  group('#open', () {
    const validPath = '/path/123/my_route';
    const invalidPath = '/path';

    test('given a valid path', () async {
      await expectLater(route.open(validPath), completes);

      final arguments = RouteArguments({'id': '123', 'name': 'my_route'});
      verify(route.mock.openPath(arguments)).called(1);
    });

    test('given a valid path and unconflicting arguments', () async {
      final initialArguments = RouteArguments({'some_argument': 123});
      await expectLater(route.open(validPath, initialArguments), completes);

      final arguments = RouteArguments({
        'id': '123',
        'name': 'my_route',
        'some_argument': 123,
      });
      verify(route.mock.openPath(arguments)).called(1);
    });

    test('given a valid path and same named arguments', () async {
      final initialArguments = RouteArguments({
        'id': 999,
        'name': 'initial name',
      });
      await expectLater(route.open(validPath, initialArguments), completes);

      // path matches take priority
      final arguments = RouteArguments({
        'id': '123',
        'name': 'my_route',
      });
      verify(route.mock.openPath(arguments)).called(1);
    });

    test('given an invalid path', () async {
      await expectLater(route.open(invalidPath), throwsUnmatchedPathException);

      verifyZeroInteractions(route.mock);
    });
  });
}
