const defaultPathPattern = '[a-zA-Z0-9-_]+';

/// Returns the matched properties in [path] by [pattern].
///
/// Returns null if it isn't a valid match for this [pattern],
/// or returns a [Map] if it matches the [pattern] with the captured properties.
///
/// Examples:
/// Given a pattern for '/path/:id/something':
/// - path '/path/123/something': returns {'id': '123'}
/// - path '/path/123': returns null
///
Map<String, String>? pathMatches(RegExp pattern, String path) {
  path = path.trim().split('/').where((s) => s.isNotEmpty).join('/');
  final match = pattern.firstMatch(path);
  if (match == null) return null;

  final result = <String, String>{};
  if (match.groupCount > 0) {
    for (final name in match.groupNames) {
      final namedGroup = match.namedGroup(name);
      if (namedGroup != null) {
        result[name] = namedGroup;
      }
    }
  }
  return result;
}

/// Builds a [RegExp] pattern based on a [path].
///
/// - [variablePattern] is used to denote the pattern for matching variables.
/// Default is a case sensitive alphanumeric + [-_] symbols.
///
/// Example of [path]s:
///
/// '/:id': returns a pattern that captures a group named 'id'
/// '/some/path/:id/:value': returns a pattern that captures 'id' and 'value'
RegExp buildPathPattern(
  String path, {
  String? variablePattern,
}) {
  variablePattern ??= defaultPathPattern;
  final paths = path.split('/').where((s) => s.isNotEmpty);
  final pattern = paths.map((path) {
    final nameMatch = RegExp(':($variablePattern)').firstMatch(path);
    if (nameMatch == null) {
      return path;
    }

    final variableName = nameMatch.group(1);
    return '(?<$variableName>$variablePattern)';
  }).join('/');
  return RegExp('^$pattern\$');
}
