import 'package:dun_diary_app/core/router/feature_router.dart';
import 'package:flutter/material.dart';

abstract class BaseFeatureRouter extends FeatureRouter {
  /// Defines the mapping between route names and their widget builders.
  /// The builder function receives the route arguments.
  Map<String, Widget Function(dynamic args)> get routes;

  @override
  Route<dynamic>? getRoute(RouteSettings settings) {
    final builder = routes[settings.name];
    if (builder != null) {
      final child = builder(settings.arguments);
      return getPageRoute(settings, child);
    }
    return null;
  }

  /// Wraps the widget in a PageRoute.
  /// Override this method to provide custom transitions or different PageRoute types (e.g. CupertinoPageRoute).
  PageRoute<dynamic> getPageRoute(RouteSettings settings, Widget child) {
    return MaterialPageRoute(settings: settings, builder: (_) => child);
  }
}
