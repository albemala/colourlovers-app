import 'package:in_app_review/in_app_review.dart';

const appleAppId = '1438312561';
// const microsoftStoreId = '9PF0Q1XP8LCX';

Future<void> showReviewDialog() async {
  final inAppReview = InAppReview.instance;
  if (await inAppReview.isAvailable()) {
    await inAppReview.requestReview();
  }
}

Future<void> openStoreListing() async {
  final inAppReview = InAppReview.instance;
  await inAppReview.openStoreListing(
    appStoreId: appleAppId,
    // microsoftStoreId: microsoftStoreId,
  );
}
