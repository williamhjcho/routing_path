import 'package:flutter/widgets.dart';

import 'route_handler.dart';

/// The base interface for opening [RouteHandler]s.
///
/// Usually there should be one [PathRouter] instance declared close to the root
/// widget to allow others to call any arbitrary routes from a [BuildContext].
///
/// Typical usage is as follows:
///
/// ```dart
/// PathRouter.of(context).open(...);
/// ```
abstract class PathRouter extends StatelessWidget
    implements RouteHandler<dynamic> {
  const PathRouter({Key? key, required this.child}) : super(key: key);

  /// {@macro flutter.widgets.child}
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      _InheritedRouter(router: this, child: child);

  /// Attempts to retrieve the closest (inherited) instance of [PathRouter] that
  /// encloses the given [context].
  ///
  /// Throws if there is no ancestor [PathRouter] in the [context].
  static PathRouter of(BuildContext context) {
    final inheritedElement =
        context.getElementForInheritedWidgetOfExactType<_InheritedRouter>();
    if (inheritedElement == null) {
      throw FlutterError(
        'PathRouter operation requested with a context that does not include '
        'a PathRouter.\n'
        'The context used to access the PathRouter must be that of a widget '
        'that is a descendant of a PathRouter widget.',
      );
    }
    final inheritedRouter = inheritedElement.widget as _InheritedRouter;
    return inheritedRouter.router;
  }

  /// Attempts to retrieve the closest (inherited) instance of [PathRouter] that
  /// encloses the given [context].
  ///
  /// Will return null if there is no ancestor [PathRouter] in the [context]..
  static PathRouter? maybeOf(BuildContext context) {
    final inheritedElement =
        context.getElementForInheritedWidgetOfExactType<_InheritedRouter>();
    final inheritedRouter = inheritedElement?.widget as _InheritedRouter?;
    return inheritedRouter?.router;
  }
}

class _InheritedRouter extends InheritedWidget {
  const _InheritedRouter({
    Key? key,
    required this.router,
    required Widget child,
  }) : super(key: key, child: child);

  final PathRouter router;

  @override
  bool updateShouldNotify(_InheritedRouter oldWidget) => false;
}
