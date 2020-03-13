# routing_path

[![Build Status](https://app.bitrise.io/app/81d3e30fd42b0a53/status.svg?token=GrYd7ygvrE3c5lflRXW4Xw&branch=master)](https://app.bitrise.io/app/81d3e30fd42b0a53)
[![codecov](https://codecov.io/gh/williamhjcho/routing_path/branch/master/graph/badge.svg)](https://codecov.io/gh/williamhjcho/routing_path)

## Description

This package was designed to be a detached interface connecting multiple features without them depending on one another. This is particularly useful when dealing with an app with multiple feature packages, for example:

In an app structure where you have a main application at root level:

```
/
  pubspec.yaml # imports the packages in 'features'
  lib/ # main application
  test/
  features/
    feature_a/
    feature_b/
    ...
```

And you need a way for `feature_a` to start/open `feature_b`, you'd first need a common interface between them to make it work.

And this is the main objective of `routing_path`:

> To be the common interface between features

## Usage

There are a few built-in classes and interfaces for convenience, but for this example we'll stick to the core ones to understand the bigger picture:

### Registering a route

First the features should create their own implementations of `RouteHandler`, which is nothing more than an entry point within that feature.

```dart
// A `RouteHandler` is the core interface, if you want to open a
// navigation Route for example, then you could use a `NavigationRouteHandler`.
class FeatureARouteHandler implements RouteHandler {
  @override
  bool canOpen(String path) => path == '/feature-a';

  @override
  Future<T> open<T>(String path, [RouteArguments arguments]) async {
    // do something

    // here you can use the arguments, that were given when
    // this route was opened. It is simply a class
    // wrapping a Map<String, dynamic>.
    // It is a class to allow custom `extensions` to be made if needed,
    // without being too broad, or too restrictive.
  }
}
```

### Registering a Router

Now that `feature_a` has a route, we need to register into the main application.

> It is assumed that the main application knows (depends on) all features

So to register it, first we need to instantiate a `Router`, which is responsible for opening a route with a given string path.

```dart
import 'packages:feature_a/feature_a.dart';
import 'packages:feature_b/feature_b.dart';

// the mixin here is only to minimize a simple list based solution,
// it is entirely optional and customizable
class AppRouter extends Router with RouteRegistererMixin {
  AppRouter({Widget child}): super(child: child);

  @override
  final List<RouteHandler> routes = [
    // This is a simple list which will be checked when someone attempts
    // to open a route.
    //
    // Note that `Router` is also a `RouteHandler`, so there is a concept of
    // allowing nested `RouteHandlers`, you can even think of
    // them as nodes in a tree.
    FeatureARouteHandler(),
    FeatureBRouteHandler(),
  ];
}
```

Then just register it at some point in the application that will be reachable by the other features (i.e. closer to the main widget app).

> Make sure the widget is reachable by BuildContext

```dart
AppRouter(
  child: MaterialApp(
    // ...
  ),
);

// or

MaterialApp(
  home: AppRouter(child: ...),
);

// or

MaterialApp(
  builder: (context, child) {
    // ...
    return AppRouter(child: child);
  },
);
```

It all depends on how your main application needs to be registered or customized.

### Opening a route

Then to open a route:

```dart
// somewhere inside a widget
Widget build(BuildContext context) {
  // (these lines could be inside a button tap callback for example)

  // This returns a Future which you can listen to, or just ignore.
  // For example, to show an loading indicator.
  Router.of(context).open('/feature-a');

  // Or if you want to also send some arguments
  Router.of(context).open('/feature-b', RouteArguments({'value': 123}));

  // ...
}
```

## Special RouteHandlers

- `NavigationRouteHandler`:
  Is a `RouteHandler` that attempts to open a navigation `Route<T>`.

  ```dart
  class MyNavigationRoute extends NavigationRouteHandler {
    @override
    bool canOpen(String path) => path == '/feature-a';

    @override
    // Notice that the returning `Route` can have a definitive type if desired.
    // Otherwise you can maintain it as a `Route` of dynamic type.
    Route<void> buildRoute(String path, [RouteArguments arguments]) {
      return MaterialPageRoute<void>(
        builder: (context) {
          return MyFeatureAScreen();
        }
      );
    }
  }
  ```

- `PathRouteHandler`:
  Is a `RouteHandler` that has a `RegExp` path matcher, able to replace the variables as needed.

  ```dart
  class MyPathRoute extends PathRouteHandler {
    MyPathRoute() : super('/path/to/:id');

    // we don't need to implement `canOpen`, it is already being done on
    // `PathRouteHandler`. In this case, it'll match anything similar to
    // `/path/to/:id`, where `:id` is a path variable

    @override
    Future<T> open<T>(String path, [RouteArguments arguments]) {
      // here we're updating  the arguments variable with the path variables
      // (if any).
      // If there were any values previously stored in arguments,
      // they are still accessible, unless the name conflicts with the path
      // variable (which will be overridden).
      arguments = replaceMatches(path, arguments);

      // do something ...
    }
  }
  ```

- Mixed `RouteHandlers`:
  It is possible to mix the behavior from both `NavigationRouteHandler` and `PathRouteHandler`, by their `mixins` and/or interfaces.

  ```dart
  // Here we're using the `PathRouteHandler` interface
  // with the `NavigationRouteHandlerMixin` to extend its functionality.
  class MixedPathRoute extends PathRouteHandler with NavigationRouteHandlerMixin {
    // the path matching behaves just like a `PathRouteHandler`
    MixedPathRoute() : super('/path/to/:id');

    @override
    // and it is expected to return a navigation `Route`
    Route buildRoute(String path, [RouteArguments arguments]) {
      arguments = replaceMatches(path, arguments);

      // do something ...
    }
  }
  ```
