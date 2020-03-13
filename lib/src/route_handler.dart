import 'errors.dart';
import 'route_arguments.dart';

/// Base interface for registering a route.
///
/// A route is associated with a path on [canOpen], and the route is opened
/// by calling [open] given the arguments.
///
/// To register a [RouteHandler] into the routing system, it must be added under
/// a [Router]. Due to how the abstraction is laid out, it can also be under
/// another [RouteHandler] (or [RouteRegistererMixin]).
///
/// To open a [RouteHandler]:
///
/// ```dart
/// Router.of(context).open(path);
/// ```
///
/// See also:
///
/// * [NavigationRouteHandler] the base visual route handler
/// * [PathRouteHandler] a patterned path route handler
/// * [RouteRegisterer] the base route registerer
/// * [Router] the base interface for opening a route
abstract class RouteHandler {
  /// Returns if this route can be open a given [path].
  bool canOpen(String path);

  /// Attempts to open this route.
  ///
  /// The [arguments] can be null and will be given to the route if it is able
  /// to be opened.
  Future<T> open<T>(String path, [RouteArguments arguments]);
}

/// Simple Route aggregator that keeps track of registered routes.
///
/// It will check the availability of internal routes **in the order they
/// were added**
///
/// See also:
///
/// * [RouteRegistererMixin] the mixin implementation for this registerer
/// * [RouteHandler] the base route interface
class RouteRegisterer with RouteRegistererMixin {
  RouteRegisterer({List<RouteHandler> routes})
      : routes = routes ?? [],
        super();

  @override
  final List<RouteHandler> routes;
}

/// Simple Route aggregator mixin that keeps track of registered routes.
///
/// It will check the availability of internal routes
/// **in the order they were added**
///
/// See also:
///
/// * [RouteHandler] the base route interface
/// * [RouteRegisterer] a concrete base implementation for this mixin
mixin RouteRegistererMixin implements RouteHandler {
  /// The currently registered [RouteHandler]s.
  ///
  /// The order where they were registered is the same which [RouteHandler] is
  /// verified.
  List<RouteHandler> get routes;

  /// Registers a [route] (cannot be null) if it wasn't registered before in
  /// [routes].
  ///
  /// See [unregister] to unregister it.
  void register(RouteHandler route) {
    assert(route != null);

    if (!routes.contains(route)) routes.add(route);
  }

  /// Unregisters a [route] from [routes] if it was already registered.
  ///
  /// Returns if it was found in [routes] or not.
  ///
  /// See [register] to register a [RouteHandler].
  bool unregister(RouteHandler route) => routes.remove(route);

  @override
  bool canOpen(String path) {
    final route = routes.firstWhere(
      (route) {
        try {
          return route.canOpen(path);
        } catch (_) {
          return false;
        }
      },
      orElse: () => null,
    );
    return route != null;
  }

  /// Attempts to open this route by finding the first capable registered route
  /// ([RouteHandler.canOpen])
  ///
  /// The [arguments] can be null and will be given to the registered route
  /// if it exists.
  ///
  /// if a capable route isn't found throws a [UnregisteredRouteException].
  @override
  Future<T> open<T>(String path, [RouteArguments arguments]) async {
    final route = routes?.firstWhere(
      (route) => route.canOpen(path),
      orElse: () => null,
    );
    if (route == null) {
      throw UnregisteredRouteException(path, arguments);
    }
    return route.open(path, arguments);
  }
}
