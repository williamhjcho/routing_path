import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:routing_path/routing_path.dart';

class _ConcretePathRouter extends PathRouter {
  const _ConcretePathRouter({Key? key, required Widget child})
      : super(key: key, child: child);

  @override
  bool canOpen(String path) => false;

  @override
  Future<dynamic> open(String path, [RouteArguments? arguments]) =>
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
    await tester.pumpWidget(_ConcretePathRouter(child: builder));
    expect(find.byWidget(builder), findsOneWidget);
  });

  group('.of', () {
    testWidgets('when in hierarchy', (tester) async {
      final router = _ConcretePathRouter(child: builder);
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

      final subRouter = _ConcretePathRouter(child: Builder(builder: (context) {
        subContext = context;
        return Container();
      }));
      final rootRouter = _ConcretePathRouter(child: Builder(builder: (context) {
        rootContext = context;
        return subRouter;
      }));
      await tester.pumpWidget(rootRouter);

      expect(PathRouter.of(rootContext), same(rootRouter));
      expect(PathRouter.of(subContext), same(subRouter));
    });

    testWidgets('does not depend on context', (tester) async {
      final builder = Builder(
        builder: expectAsync1(
          (context) => Container(),
          // will only be called once since the ancestor doesn't propagate
          // changes
          count: 1,
        ),
      );
      // pumping first instance
      await tester.pumpWidget(_ConcretePathRouter(child: builder));

      // pumping new instance
      await tester.pumpWidget(_ConcretePathRouter(child: builder));
    });

    testWidgets(
      'StatefulWidgets can call at appropriate times',
      (tester) async {
        await tester.pumpWidget(
          _ConcretePathRouter(
            child: _CustomStateful(
              onInitState: expectAsync1(
                (context) => expect(PathRouter.of(context), isNotNull),
                count: 1,
              ),
              onBuild: expectAsync1(
                (context) => expect(PathRouter.of(context), isNotNull),
                count: 1,
              ),
              onDidChangeDependencies: expectAsync1(
                (context) => expect(PathRouter.of(context), isNotNull),
                count: 1,
              ),
            ),
          ),
        );
      },
    );
  });

  group('.maybeOf', () {
    testWidgets('when in hierarchy', (tester) async {
      final router = _ConcretePathRouter(child: builder);
      await tester.pumpWidget(router);
      expect(PathRouter.maybeOf(capturedContext!), same(router));
    });

    testWidgets('when not in hierarchy', (tester) async {
      await tester.pumpWidget(builder);
      expect(PathRouter.maybeOf(capturedContext!), isNull);
    });

    testWidgets('when there are multiple routers in the hierarchy',
        (tester) async {
      late BuildContext rootContext, subContext;

      final subRouter = _ConcretePathRouter(child: Builder(builder: (context) {
        subContext = context;
        return Container();
      }));
      final rootRouter = _ConcretePathRouter(child: Builder(builder: (context) {
        rootContext = context;
        return subRouter;
      }));
      await tester.pumpWidget(rootRouter);

      expect(PathRouter.maybeOf(rootContext), same(rootRouter));
      expect(PathRouter.maybeOf(subContext), same(subRouter));
    });
  });
}

class _CustomStateful extends StatefulWidget {
  const _CustomStateful({
    Key? key,
    this.onInitState,
    this.onBuild,
    this.onDidChangeDependencies,
  }) : super(key: key);

  final ValueSetter<BuildContext>? onInitState;
  final ValueSetter<BuildContext>? onBuild;
  final ValueSetter<BuildContext>? onDidChangeDependencies;

  @override
  _CustomStatefulState createState() => _CustomStatefulState();
}

class _CustomStatefulState extends State<_CustomStateful> {
  @override
  void initState() {
    super.initState();
    widget.onInitState?.call(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.onDidChangeDependencies?.call(context);
  }

  @override
  Widget build(BuildContext context) {
    widget.onBuild?.call(context);
    return Container();
  }
}
