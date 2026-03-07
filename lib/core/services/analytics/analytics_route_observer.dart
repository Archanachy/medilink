import 'package:flutter/material.dart';
import 'package:medilink/core/services/analytics/analytics_service.dart';

/// Custom Route Observer for tracking screen navigation
class AnalyticsRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  final AnalyticsService _analytics = AnalyticsService.instance;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _trackScreenView(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      _trackScreenView(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) {
      _trackScreenView(previousRoute);
    }
  }

  void _trackScreenView(Route<dynamic> route) {
    final routeName = route.settings.name;
    if (routeName != null && routeName.isNotEmpty) {
      _analytics.logScreenView(
        screenName: routeName,
        screenClass: route.runtimeType.toString(),
      );
    }
  }
}
