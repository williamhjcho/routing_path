import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:routing_path/routing_path.dart';

class ConcreteRouter extends Router {
  const ConcreteRouter({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool canOpen(String path) => false;

  @override
  Future<T> open<T>(String path, [dynamic arguments]) =>
      Future.error('Some error');
}

void main() {
  BuildContext capturedContext;

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
      expect(Router.of(capturedContext), same(router));
    });

    testWidgets('when not in hierarchy', (tester) async {
      await tester.pumpWidget(builder);
      expect(Router.of(capturedContext), isNull);
    });

    testWidgets('when there are multiple routers in the hierarchy',
        (tester) async {
      BuildContext rootContext, subContext;

      final subRouter = ConcreteRouter(child: Builder(builder: (context) {
        subContext = context;
        return Container();
      }));
      final rootRouter = ConcreteRouter(child: Builder(builder: (context) {
        rootContext = context;
        return subRouter;
      }));
      await tester.pumpWidget(rootRouter);

      expect(Router.of(rootContext), same(rootRouter));
      expect(Router.of(subContext), same(subRouter));
    });
  });
}
