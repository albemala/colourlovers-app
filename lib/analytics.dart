import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void configureSentry(SentryFlutterOptions options) {
  options
    ..dsn = kReleaseMode
        ? 'https://1325d21f75d03597ffa809f824b646c9@o562204.ingest.us.sentry.io/4509445321064448'
        : ''
    ..beforeSend = _beforeSend
    ..debug = kDebugMode;
}

SentryEvent _beforeSend(SentryEvent event, Hint hint) {
  return event.copyWith(
    user: SentryUser(id: ''),
    contexts: event.contexts.copyWith(
      culture: const SentryCulture(),
      device: const SentryDevice(),
    ),
  );
}

Future<void> captureException(dynamic exception) async {
  await Sentry.captureException(exception, stackTrace: StackTrace.current);
}
