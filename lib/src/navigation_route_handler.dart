import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'route_arguments.dart';
import 'route_handler.dart';

/// Base [RouteHandler] interface for opening an arbitrary [Route].
///
/// Subclasses only need to implement [canOpen] and [buildRoute].
///
/// See [NavigationRouteHandlerMixin] for the core implementations.
abstract class NavigationRouteHandler<T extends Object?>
    with NavigationRouteHandlerMixin<T> {
  /// Creates a route handler that presents [Route]
  ///
  /// The [navigatorKey] is the main navigator where this route will attempt
  /// to present the generated route from (defaults to [rootNavigatorKey]).
  /// After the [Route] pops it will wait [popDelay] before calling
  /// [SystemNavigator.pop] (can be null).
  NavigationRouteHandler({this.navigatorKey}) : super();

  @override
  final GlobalKey<NavigatorState>? navigatorKey;

  /// This key is used as a fallback when the [NavigationRouteHandler] instance
  /// didn't receive a navigatorKey instance.
  ///
  /// Make sure this key is registered to a [Navigator] before any attempts
  /// to open the route.
  static GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();
}

/// The [NavigationRouteHandler] core implementation for custom [RouteHandler]s
mixin NavigationRouteHandlerMixin<T extends Object?>
    implements RouteHandler<T> {
  GlobalKey<NavigatorState>? get navigatorKey => null;

  @override
  Future<T?> open(String path, [RouteArguments? arguments]) {
    final route = buildRoute(path, arguments);
    final navigator = navigatorKey ?? NavigationRouteHandler.rootNavigatorKey;
    // TODO: allow other presentation methods (replace, pop replace, etc)
    final navigatorState = navigator.currentState;
    assert(() {
      if (navigatorState == null) {
        throw FlutterError(
          'Tried to call $runtimeType.open($path, $arguments) with a null '
          'Navigator.\n'
          'Make sure it is on the widget tree',
        );
      }
      return true;
    }());
    return navigatorState!.push<T?>(route);
  }

  /// Builds the [Route] which will be pushed on top of the navigator key.
  Route<T> buildRoute(String path, [RouteArguments? arguments]);
}
