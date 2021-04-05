// Mocks generated by Mockito 5.0.3 from annotations
// in routing_path/test/navigation_route_handler_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:flutter/src/widgets/navigator.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:routing_path/src/navigation_route_handler.dart' as _i3;
import 'package:routing_path/src/route_arguments.dart' as _i5;

// ignore_for_file: comment_references
// ignore_for_file: unnecessary_parenthesis

class _FakeRoute<T> extends _i1.Fake implements _i2.Route<T> {}

/// A class which mocks [NavigationRouteHandler].
///
/// See the documentation for Mockito's code generation for more information.
class MockNavigationRouteHandler extends _i1.Mock
    implements _i3.NavigationRouteHandler {
  MockNavigationRouteHandler() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<T?> open<T>(String? path, [_i5.RouteArguments? arguments]) =>
      (super.noSuchMethod(Invocation.method(#open, [path, arguments]),
          returnValue: Future.value(null)) as _i4.Future<T?>);
  @override
  _i2.Route<T> buildRoute<T>(String? path, [_i5.RouteArguments? arguments]) =>
      (super.noSuchMethod(Invocation.method(#buildRoute, [path, arguments]),
          returnValue: _FakeRoute<T>()) as _i2.Route<T>);
}
