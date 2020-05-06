import 'package:flutter/material.dart';
import 'package:routing_path/routing_path.dart';

import 'feature_a/route.dart';
import 'feature_b/route.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'routing_path demo',
      // The default key for the root (or main) navigator that you want all the
      // `NavigationRouteHandler`'s routes to start from.
      navigatorKey: NavigationRouteHandler.rootNavigatorKey,
      builder: (context, child) {
        // it could be declared here in `builder`, or it could wrap the whole
        // `MaterialApp` widget. It must be accessible for all descendant
        // widgets on the widget tree (`BuildContext`)
        return MainAppRouter(child: child);
      },
      home: MainHomePage(),
    );
  }
}

/// This is the main `Router` instance that will be inserted into the
/// widget tree. It is responsible for registering and opening [RouteHandler]s
/// when a `Router.of(context).open(...)` is called.
class MainAppRouter extends Router with RouteRegistererMixin {
  MainAppRouter({Widget child}) : super(child: child);

  @override
  final List<RouteHandler> routes = [
    // Ideally, these feature routes are completely isolated in a separate
    // directory or even package.
    FeatureARoute(),
    FeatureBRoute(),
  ];
}

class MainHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('HOME'),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'This is a simple recursive example of a main application '
              'registering two separate features (A and B) and allowing '
              'them to be opened from anywhere using the `Route` interface.'
              '\n\n'
              'Tap a button to open a feature flow (they are visually '
              'identical)',
              textAlign: TextAlign.justify,
              style: theme.textTheme.bodyText2,
            ),
            const SizedBox(height: 24),
            OutlineButton(
              textColor: Colors.deepPurpleAccent,
              onPressed: () => Router.of(context).open(
                '/feature-a',
                RouteArguments({'opened_by': 'MAIN HOME'}),
              ),
              child: const Text(
                'OPEN FEATURE A',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            OutlineButton(
              textColor: Colors.indigo,
              onPressed: () => Router.of(context).open(
                '/feature-b',
                RouteArguments({'opened_by': 'MAIN HOME'}),
              ),
              child: const Text(
                'OPEN FEATURE B',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
