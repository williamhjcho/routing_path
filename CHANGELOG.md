## Next version

* Renamed `PathRouteHandler` to `PatternRouteHandler`
* Refactor `PathRouter.of` to not depend on ancestor
  It means it is now safe to call `PathRouter.of` at `initState` and other places of a `StatefulWidget`

## [0.1.0-nullsafety.0]

* Migrates to null-safety
* Renames `Router -> PathRouter`
* Refactors `PathRouteHandler.pattern`
  Makes it a getter property initialized at constructor (final)

## [0.0.1+3]

* Removes warnings for flutter stable 1.17

## [0.0.1+2]

* Adds example app

## [0.0.1+1]

* Splits NavigationRouteHandler with a mixin
* Splits PathRouteHandler with a mixin
* Removes UnmatchedPathException

## [0.0.1]

* Adds core implementation
* Adds regexp paths
* Adds README
