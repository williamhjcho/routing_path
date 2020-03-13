import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'route_arguments.dart';
import 'route_handler.dart';

/// Base [RouteHandler] interface for opening an arbitrary [Route].
///
/// Subclasses only need to implement [canOpen] and [buildRoute].
abstract class NavigationRouteHandler extends RouteHandler {
  /// Creates a route handler that presents [Route]
  ///
  /// The [navigatorKey] is the main navigator where this route will attempt
  /// to present the generated route from (defaults to [rootNavigatorKey]).
  /// After the [Route] pops it will wait [popDelay] before calling
  /// [SystemNavigator.pop] (can be null).
  NavigationRouteHandler({GlobalKey<NavigatorState> navigatorKey})
      : _navigatorKey = navigatorKey,
        super();

  final GlobalKey<NavigatorState> _navigatorKey;

  @override
  Future<T> open<T>(String path, [RouteArguments arguments]) {
    final route = buildRoute(path, arguments);
    assert(route != null);
    final navigator = _navigatorKey ?? rootNavigatorKey;
    // TODO: allow other presentation methods (replace, pop replace, etc)
    return navigator.currentState.push(route);
  }

  /// Builds the [Route] which will be pushed on top of the navigator key.
  Route<dynamic> buildRoute(String path, [RouteArguments arguments]);

  /// This key is used as a fallback when the [NavigationRouteHandler] instance
  /// didn't receive a navigatorKey instance.
  ///
  /// Make sure this key is registered to a [Navigator] before any attempts
  /// to open the route.
  static GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();
}
