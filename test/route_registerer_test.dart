import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:routing_path/routing_path.dart';

import 'route_registerer_test.mocks.dart';
import 'utils.dart';

@GenerateMocks([RouteHandler])
void main() {
  const path = '/path';

  late RouteRegisterer registerer;

  setUp(() {
    registerer = RouteRegisterer();
  });

  group('#register', () {
    test('adds only if not already registered', () {
      final route = MockRouteHandler();
      expect(registerer.routes, isEmpty);
      registerer.register(route);
      expect(registerer.routes, [route]);
      registerer.register(route);
      expect(registerer.routes, [route]);
    });

    test('adds to the registry in order', () {
      expect(registerer.routes, isEmpty);

      final route0 = MockRouteHandler();
      registerer.register(route0);
      expect(registerer.routes, [route0]);

      final route1 = MockRouteHandler();
      registerer.register(route1);
      expect(registerer.routes, [route0, route1]);
    });
  });

  group('#remove', () {
    group('with an unregistered registrar', () {
      test('when empty', () {
        expect(registerer.unregister(MockRouteHandler()), isFalse);
      });

      test('when not empty', () {
        final route = MockRouteHandler();
        registerer.register(route);
        expect(registerer.unregister(MockRouteHandler()), isFalse);
        expect(registerer.routes, [route]);
      });
    });

    test('given a registered registrar', () {
      final route = MockRouteHandler();
      registerer.register(route);

      expect(registerer.unregister(route), isTrue);
      expect(registerer.routes, isEmpty);
    });
  });

  group('#canOpen', () {
    late MockRouteHandler route;

    setUp(() {
      route = MockRouteHandler();
    });

    test('when no routes are registered', () {
      expect(registerer.canOpen(path), isFalse);
    });

    test('when no capable routes are registered', () {
      when(route.canOpen(any)).thenReturn(false);
      registerer.register(route);
      expect(registerer.canOpen(path), isFalse);
    });

    test('when a capable route is registered', () {
      when(route.canOpen(any)).thenReturn(true);
      registerer.register(route);
      expect(registerer.canOpen(path), isTrue);
    });

    test('when a route errors', () {
      const someError = 'Error';
      registerer.register(route);

      when(route.canOpen(any)).thenThrow(someError);
      expect(registerer.canOpen(path), isFalse);
    });
  });

  group('#open', () {
    late MockRouteHandler route;

    setUp(() {
      route = MockRouteHandler();
    });

    test('when no routes are registered', () {
      expect(
        registerer.open<dynamic>(path),
        throwsUnregisteredRouteException,
      );
    });

    test('when no capable routes are registered', () {
      when(route.canOpen(any)).thenReturn(false);
      registerer.register(route);
      expect(
        () => registerer.open<dynamic>(path),
        throwsUnregisteredRouteException,
      );
    });

    group('when a capable route is registered', () {
      setUp(() {
        when(route.canOpen(any)).thenReturn(true);
        when(route.open<dynamic>(any, any)).thenAnswer((_) async {});
        registerer.register(route);
      });

      test('calls route #open once', () async {
        await expectLater(registerer.open<dynamic>(path), completes);
        verify(route.open<dynamic>(path)).called(1);
      });

      test('sends the arguments forward', () async {
        final arguments = RouteArguments({'': 'My arguments'});
        await expectLater(registerer.open<dynamic>(path, arguments), completes);
        verify(route.open<dynamic>(path, arguments));
      });

      test('propagates error forward', () {
        const someError = 'Some Error';
        when(route.open<dynamic>(any, any))
            .thenAnswer((_) => Future<void>.error(someError));
        expect(registerer.open<dynamic>(path), throwsA(someError));
      });
    });

    test('verifies registries in order', () async {
      final routes = List.generate(3, (_) => MockRouteHandler());
      routes.forEach(registerer.register);

      when(routes[0].canOpen(any)).thenReturn(false);
      when(routes[1].canOpen(any)).thenReturn(true);
      when(routes[1].open(path, null)).thenAnswer((_) async => {});
      when(routes[2].canOpen(any)).thenReturn(true);

      await expectLater(registerer.open<dynamic>(path), completes);

      verify(routes[0].canOpen(any));
      verify(routes[1].canOpen(any));
      verify(routes[1].open<dynamic>(path));
      verifyZeroInteractions(routes[2]);
    });
  });
}
