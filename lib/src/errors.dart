import 'route_arguments.dart';

/// Exception thrown when attempting to open a route but none registered were
/// capable of opening it.
///
/// See [Router] and [RouteHandler] for more information about how to go about
/// registering and opening routes.
class UnregisteredRouteException implements Exception {
  const UnregisteredRouteException(this.route, [this.arguments])
      : assert(route != null);

  /// The route that was attempted to be opened.
  final String route;

  /// The arguments that were used when attempting to open this route.
  final RouteArguments arguments;

  @override
  String toString() => arguments == null
      ? 'RouteNotFoundException($route)'
      : 'RouteNotFoundException($route, arguments: $arguments)';
}

/// Exception thrown when attempting to open a route but it didn't actually
/// matched the required path.
///
/// See [PathRouteHandler] on how it uses a path pattern.
class UnmatchedPathException implements Exception {
  UnmatchedPathException(this.path, this.pattern);

  /// The path that was attempted to be opened.
  final String path;

  /// The pattern used to match the [path].
  final Pattern pattern;

  @override
  String toString() => 'UnmatchedPathException($path, $pattern)';
}
