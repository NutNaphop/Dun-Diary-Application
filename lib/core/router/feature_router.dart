import 'package:flutter/material.dart';

abstract class FeatureRouter {
  Route<dynamic>? getRoute(RouteSettings settings);
}
