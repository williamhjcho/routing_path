import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:routing_path/routing_path.dart';

class ConcreteRouter extends PathRouter {
  const ConcreteRouter({Key? key, required Widget child})
      : super(key: key, child: child);

  @override
  bool canOpen(String path) => false;

  @override
  Future<T?> open<T>(String path, [RouteArguments? arguments]) =>
      Future.error('Some error');
}

void main() {
  BuildContext? capturedContext;

  final builder = Builder(builder: (context) {
    capturedContext = context;
    return Container();
  });

  setUp(() {
    capturedContext = null;
  });

  testWidgets('given child', (tester) async {
    await tester.pumpWidget(ConcreteRouter(child: builder));
    expect(find.byWidget(builder), findsOneWidget);
  });

  group('.of', () {
    testWidgets('when in hierarchy', (tester) async {
      final router = ConcreteRouter(child: builder);
      await tester.pumpWidget(router);
      expect(PathRouter.of(capturedContext!), same(router));
    });

    testWidgets('when not in hierarchy', (tester) async {
      await tester.pumpWidget(builder);
      expect(() => PathRouter.of(capturedContext!), throwsFlutterError);
    });

    testWidgets('when there are multiple routers in the hierarchy',
        (tester) async {
      late BuildContext rootContext, subContext;

      final subRouter = ConcreteRouter(child: Builder(builder: (context) {
        subContext = context;
        return Container();
      }));
      final rootRouter = ConcreteRouter(child: Builder(builder: (context) {
        rootContext = context;
        return subRouter;
      }));
      await tester.pumpWidget(rootRouter);

      expect(PathRouter.of(rootContext), same(rootRouter));
      expect(PathRouter.of(subContext), same(subRouter));
    });
  });
}
