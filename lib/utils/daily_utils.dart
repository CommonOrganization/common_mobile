import 'package:common/models/daily/daily.dart';

bool hasKeywordDaily(
    {required Daily daily, required String keyword}) {
  if (daily.tagList.contains(keyword)) return true;
  if (daily.detailCategory.contains(keyword)) return true;
  if (daily.content.contains(keyword)) return true;
  return false;
}
