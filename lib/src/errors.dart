import 'route_arguments.dart';

/// Exception thrown when attempting to open a route but none registered were
/// capable of opening it.
///
/// See [Router] and [RouteHandler] for more information about how to go about
/// registering and opening routes.
class UnregisteredRouteException implements Exception {
  const UnregisteredRouteException(this.route, [this.arguments]) : super();

  /// The route that was attempted to be opened.
  final String route;

  /// The arguments that were used when attempting to open this route.
  final RouteArguments? arguments;

  @override
  String toString() => arguments == null
      ? 'RouteNotFoundException($route)'
      : 'RouteNotFoundException($route, arguments: $arguments)';
}
