import 'errors.dart';
import 'route_arguments.dart';
import 'route_handler.dart';
import 'utils/path_matcher.dart';

/// A patterned [RouteHandler] which takes a [path] and creates an equivalent
/// pattern for it.
///
/// For example, when taking a path of type `/path/:id/to/:name`, it'll match
/// `/path/123/to/some-name` and add the named variables into the
/// [RouteArguments] in [openPath].
///
/// See also:
///
/// * [VisualRouteHandler] the base visual route handler
abstract class PathRouteHandler implements RouteHandler {
  PathRouteHandler(this.path, [String variablePattern])
      : assert(path != null),
        _pattern = buildPathPattern(path, variablePattern: variablePattern),
        super();

  /// The path pattern to be used for matching this route.
  ///
  /// Cannot be null and should have a pattern like
  /// `/path/:id/to/:name`
  ///
  /// A simple path with no names is also acceptable.
  final String path;
  final RegExp _pattern;

  @override
  bool canOpen(String path) => pathMatches(_pattern, path) != null;

  @override
  Future<T> open<T>(String path, [RouteArguments arguments]) async {
    final matches = pathMatches(_pattern, path);
    if (matches == null) throw UnmatchedPathException(path, _pattern);

    arguments ??= RouteArguments({});
    return openPath(arguments..addAll(matches));
  }

  /// Attempts to open this route with the matched [path].
  ///
  /// The [arguments] may contain [path] named substitutions (as strings) and
  /// whatever other arguments given when [Router] was called with.
  ///
  /// The [path] substitutions takes priority over previously declared
  /// [arguments] values.
  Future<T> openPath<T>(RouteArguments arguments);
}
