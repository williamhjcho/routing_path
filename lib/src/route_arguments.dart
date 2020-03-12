import 'dart:collection';

/// The arguments given to a [RouteHandler] when opening a new route.
///
/// Obs: This is a [Map] rather than [dynamic] to allow extensions on top of
/// the type, instead of relying on dynamic casting.
class RouteArguments extends MapView<String, dynamic> {
  RouteArguments([Map<String, dynamic> map]) : super(map ?? {});
}
