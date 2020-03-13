import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:routing_path/routing_path.dart';

class MockRouteBuilder extends Mock implements NavigationRouteHandler {
  @override
  Route<dynamic> buildRoute(String path, [RouteArguments arguments]);
}

class _SimpleVisualRouteHandler extends NavigationRouteHandler {
  _SimpleVisualRouteHandler([GlobalKey<NavigatorState> navigatorKey])
      : super(navigatorKey: navigatorKey);

  final MockRouteBuilder mock = MockRouteBuilder();

  @override
  bool canOpen(String path) => mock.canOpen(path);

  @override
  Route<dynamic> buildRoute(String path, [RouteArguments arguments]) =>
      mock.buildRoute(path, arguments);
}

void main() {
  const path = '/some/path';
  GlobalKey<NavigatorState> navigatorKey;
  _SimpleVisualRouteHandler route;

  Widget _buildNavigator() => Directionality(
        textDirection: TextDirection.ltr,
        child: Navigator(
          key: navigatorKey,
          onGenerateRoute: (_) => MaterialPageRoute(
            builder: (_) => Container(),
          ),
        ),
      );

  setUp(() {
    navigatorKey = GlobalKey<NavigatorState>();
  });

  group('#open', () {
    testWidgets('when buildRoute returns null', (tester) async {
      route = _SimpleVisualRouteHandler(navigatorKey);
      when(route.mock.buildRoute(any, any)).thenAnswer((_) => null);

      await tester.pumpWidget(_buildNavigator());
      expect(() => route.open(path), throwsAssertionError);
    });

    testWidgets('given navigatorKey', (tester) async {
      route = _SimpleVisualRouteHandler(navigatorKey);
      when(route.mock.buildRoute(any, any)).thenAnswer(
        (_) => PageRouteBuilder<void>(
          pageBuilder: (context, anim1, anim2) => Container(),
        ),
      );

      await tester.pumpWidget(_buildNavigator());
      expect(route.open(path), completes);
      await tester.pumpAndSettle();
      verify(route.mock.buildRoute(path)).called(1);

      // should close the opened Route
      expect(navigatorKey.currentState.pop(), isTrue);
    });

    testWidgets('when rootNavigatorKey is changed', (tester) async {
      route = _SimpleVisualRouteHandler();
      when(route.mock.buildRoute(any, any)).thenAnswer(
        (_) => PageRouteBuilder<void>(
          pageBuilder: (context, anim1, anim2) => Container(),
        ),
      );
      NavigationRouteHandler.rootNavigatorKey = navigatorKey;

      await tester.pumpWidget(_buildNavigator());
      expect(route.open(path), completes);
      await tester.pumpAndSettle();

      // should close the opened Route
      expect(
        NavigationRouteHandler.rootNavigatorKey.currentState.pop(),
        isTrue,
      );
    });
  });
}
