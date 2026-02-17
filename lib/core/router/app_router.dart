import 'package:dun_diary_app/core/router/router_registry.dart';
import 'package:dun_diary_app/core/services/app_logger.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic> generate(RouteSettings settings) {
    AppLogger.debug('Navigate to: ${settings.name}');

    final route = RouterRegistry.instance.generateRoute(settings);
    if (route != null) return route;

    return _errorRoute('No route defined for ${settings.name}');
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 50),
                const SizedBox(height: 10),
                Text(message, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        );
      },
    );
  }
}
