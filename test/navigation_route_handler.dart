import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:routing_path/routing_path.dart';

class MockRouteBuilder extends Mock implements RouteHandler {
  Route<dynamic> buildRoute(String path, [dynamic arguments]);
}

class _SimpleVisualRouteHandler extends NavigationRouteHandler {
  _SimpleVisualRouteHandler(GlobalKey<NavigatorState> navigatorKey)
      : super(navigatorKey: navigatorKey);

  final MockRouteBuilder mock = MockRouteBuilder();

  @override
  bool canOpen(String path) => mock.canOpen(path);

  @override
  Route<dynamic> buildRoute(String path, [dynamic arguments]) =>
      mock.buildRoute(path, arguments);
}

void main() {
  const path = '/some/path';
  final navigatorKey = GlobalKey<NavigatorState>();
  const methodChannel =
      OptionalMethodChannel('flutter/platform', JSONMethodCodec());
  _SimpleVisualRouteHandler route;
  bool systemNavigatorPopCalled;

  setUp(() {
    methodChannel.setMockMethodCallHandler((call) async {
      if (call.method == 'SystemNavigator.pop') systemNavigatorPopCalled = true;
      return null;
    });

    systemNavigatorPopCalled = false;
    route = _SimpleVisualRouteHandler(navigatorKey);
  });

  tearDown(() {
    methodChannel.setMockMethodCallHandler(null);
  });

  group('#open navigation', () {
    Future<void> pumpNavigator(WidgetTester tester) async {
      when(route.mock.buildRoute(any, any)).thenAnswer(
        (_) => PageRouteBuilder<void>(
          pageBuilder: (context, anim1, anim2) => Container(),
        ),
      );

      await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: Navigator(
          key: navigatorKey,
          onGenerateRoute: (settings) => PageRouteBuilder<dynamic>(
            pageBuilder: (context, anim1, anim2) => Container(),
          ),
        ),
      ));
    }

    testWidgets('calls #buildRoute once', (tester) async {
      await pumpNavigator(tester);
      route.open<dynamic>(path);
      await tester.pumpAndSettle();

      verify(route.mock.buildRoute(path, null)).called(1);
    });

    group('when route pops', () {
      Future<dynamic> pumpOpenAndPopNavigator(WidgetTester tester) async {
        await pumpNavigator(tester);
        final openFuture = route.open<dynamic>(path, null);
        await tester.pumpAndSettle();
        expect(navigatorKey.currentState.pop(), isTrue);
        return openFuture;
      }

      testWidgets('when is not from native', (tester) async {
        await pumpOpenAndPopNavigator(tester);
        expect(systemNavigatorPopCalled, isFalse);
      });

      testWidgets('when is from native without delay', (tester) async {
        await pumpOpenAndPopNavigator(tester);
        expect(systemNavigatorPopCalled, isTrue);
      });

      testWidgets('when is from native with delay', (tester) async {
        const popDelay = Duration(seconds: 1);
        await pumpOpenAndPopNavigator(tester);
        expect(systemNavigatorPopCalled, isFalse);

        await tester.pump(const Duration(milliseconds: 1));
        expect(systemNavigatorPopCalled, isFalse);

        await tester.pump(popDelay);
        expect(systemNavigatorPopCalled, isTrue);
      });
    });
  });
}
