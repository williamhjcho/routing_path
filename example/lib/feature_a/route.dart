import 'package:flutter/material.dart';
import 'package:routing_path/routing_path.dart';

import 'home.dart';

class FeatureARoute extends NavigationRouteHandler {
  @override
  bool canOpen(String path) => path == '/feature-a';

  @override
  Route<T> buildRoute<T>(String path, [RouteArguments? arguments]) {
    return MaterialPageRoute(
      builder: (context) => FeatureAHomePage(
        openedBy: arguments?['opened_by'],
      ),
    );
  }
}
