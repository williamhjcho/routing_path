import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/src/type_matcher.dart';
import 'package:mockito/mockito.dart';
import 'package:routing_path/routing_path.dart';

// ignore_for_file: type_annotate_public_apis
final isUnregisteredRouteException = isA<UnregisteredRouteException>();
final throwsUnregisteredRouteException = throwsA(isUnregisteredRouteException);

final isUnmatchedPathException = isA<UnmatchedPathException>();
final throwsUnmatchedPathException = throwsA(isUnmatchedPathException);

class MockNavigationRouteHandler extends Mock
    implements NavigationRouteHandler {}

class MockPathRouteHandler extends Mock implements PathRouteHandler {}
