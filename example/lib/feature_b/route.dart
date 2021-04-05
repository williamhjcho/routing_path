import 'package:flutter/material.dart';
import 'package:routing_path/routing_path.dart';

import 'home.dart';

class FeatureBRoute extends NavigationRouteHandler {
  @override
  bool canOpen(String path) => path == '/feature-b';

  @override
  Route<T> buildRoute<T>(String path, [RouteArguments? arguments]) {
    return MaterialPageRoute(
      builder: (context) => FeatureBHomePage(
        openedBy: arguments?['opened_by'],
      ),
    );
  }
}
