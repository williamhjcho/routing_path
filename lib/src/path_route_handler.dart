import 'route_arguments.dart';
import 'route_handler.dart';
import 'utils/path_matcher.dart';

/// A patterned [RouteHandler] which takes a [path] and creates an equivalent
/// pattern for it.
///
/// For example, when taking a path of type `/path/:id/to/:name`, it'll match
/// `/path/123/to/some-name`, to use the arguments captured, call
/// [replaceMatches] inside [open].
///
/// See also:
///
/// * [NavigationRouteHandler] the base visual route handler
/// * [PathRouteHandlerMixin] for the core implementation
abstract class PathRouteHandler with PathRouteHandlerMixin {
  PathRouteHandler(String path, [String? variablePattern]) : super() {
    setPattern(path, variablePattern);
  }
}

/// The [PathRouteHandler] core implementation for [RouteHandler]s.
mixin PathRouteHandlerMixin implements RouteHandler {
  /// The path pattern to be used for matching this route.
  ///
  /// Cannot be null and should have a pattern like
  /// `/path/:id/to/:name`
  ///
  /// A simple path with no names is also acceptable.
  ///
  /// Use [setPattern] to update its value
  late RegExp pattern;

  /// Updates the [pattern] given a [path] and its [variablePattern]s.
  ///
  /// [path] cannot be null.
  void setPattern(String path, [String? variablePattern]) {
    pattern = buildPathPattern(path, variablePattern: variablePattern);
  }

  @override
  bool canOpen(String path) => pathMatches(pattern, path) != null;

  /// Replaces the matches (if any) from [path] into [arguments].
  ///
  /// If [arguments] is null, a new one is created.
  RouteArguments? replaceMatches(String path, RouteArguments? arguments) {
    final matches = pathMatches(pattern, path);
    if (matches != null) {
      arguments ??= RouteArguments({});
      arguments.addAll(matches);
    }
    return arguments;
  }
}
