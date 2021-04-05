// Mocks generated by Mockito 5.0.3 from annotations
// in routing_path/test/route_registerer_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:routing_path/src/route_arguments.dart' as _i4;
import 'package:routing_path/src/route_handler.dart' as _i2;

// ignore_for_file: comment_references
// ignore_for_file: unnecessary_parenthesis

/// A class which mocks [RouteHandler].
///
/// See the documentation for Mockito's code generation for more information.
class MockRouteHandler extends _i1.Mock implements _i2.RouteHandler {
  MockRouteHandler() {
    _i1.throwOnMissingStub(this);
  }

  @override
  bool canOpen(String? path) => (super
          .noSuchMethod(Invocation.method(#canOpen, [path]), returnValue: false)
      as bool);
  @override
  _i3.Future<T?> open<T>(String? path, [_i4.RouteArguments? arguments]) =>
      (super.noSuchMethod(Invocation.method(#open, [path, arguments]),
          returnValue: Future.value(null)) as _i3.Future<T?>);
}
