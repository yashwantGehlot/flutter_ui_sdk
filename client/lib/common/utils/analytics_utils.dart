import 'package:finvu_flutter_sdk/common/utils/analytics_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class FinvuAnalytics {
  static void logEvent(AnalyticsEvent event,
      {Map<String, Object?>? parameters = const {}}) {
    FirebaseAnalytics.instance.logEvent(
      name: event.name,
      parameters: parameters,
    );
  }

  static void logScreenView(String screenName) {
    FirebaseAnalytics.instance.logEvent(
      name: 'finvu_screen_view',
      parameters: {
        'page': screenName,
      },
    );
  }
}
