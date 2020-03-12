import 'package:flutter/widgets.dart';

import 'route_handler.dart';

/// The base interface for opening [RouteHandler]s.
///
/// Usually there should be one [Router] instance declared close to the root
/// widget to allow others to call any arbitrary routes from a [BuildContext].
///
/// Typical usage is as follows:
///
/// ```dart
/// Router.of(context).open(...);
/// ```
abstract class Router extends StatelessWidget implements RouteHandler {
  const Router({Key key, this.child}) : super(key: key);

  /// {@macro flutter.widgets.child}
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      _InheritedRouter(router: this, child: child);

  /// Attempts to retrieve the closest (inherited) instance of this class that
  /// encloses the given [context].
  ///
  /// May return null if not found.
  static Router of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_InheritedRouter>()?.router;
}

class _InheritedRouter extends InheritedWidget {
  const _InheritedRouter({
    Key key,
    @required this.router,
    Widget child,
  }) : super(key: key, child: child);

  final Router router;

  @override
  bool updateShouldNotify(_InheritedRouter oldWidget) =>
      oldWidget.router != router;
}
