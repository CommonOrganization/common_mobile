import 'package:common/models/club_gathering/club_gathering.dart';
import 'package:common/models/one_day_gathering/one_day_gathering.dart';

bool hasKeywordOneDayGathering({required OneDayGathering gathering, required String keyword}) {
  if (gathering.tagList.contains(keyword)) return true;
  if (gathering.detailCategory.contains(keyword)) return true;
  if ((gathering.place['city'] as String).contains(keyword)) return true;
  if ((gathering.place['county'] as String).contains(keyword)) return true;
  if ((gathering.place['detail'] as String).contains(keyword)) return true;
  if (gathering.title.contains(keyword)) return true;
  return false;
}

bool hasKeywordClubGathering({required ClubGathering gathering, required String keyword}) {
  if (gathering.tagList.contains(keyword)) return true;
  if (gathering.detailCategory.contains(keyword)) return true;
  if (gathering.cityList.contains(keyword)) return true;
  if (gathering.title.contains(keyword)) return true;
  return false;
}
