import 'package:common/constants/constants_enum.dart';
import 'package:common/models/club_gathering/club_gathering.dart';
import 'package:common/models/one_day_gathering/one_day_gathering.dart';

GatheringType getGatheringType(String gatheringId) {
  if (gatheringId.startsWith('club')) return GatheringType.club;
  return GatheringType.oneDay;
}

bool hasKeywordOneDayGathering(
    {required OneDayGathering gathering, required String keyword}) {
  if (gathering.tagList.contains(keyword)) return true;
  if (gathering.detailCategory.contains(keyword)) return true;
  if ((gathering.place['city'] as String).contains(keyword)) return true;
  if ((gathering.place['county'] as String).contains(keyword)) return true;
  if ((gathering.place['detail'] as String).contains(keyword)) return true;
  if (gathering.title.contains(keyword)) return true;
  if (gathering.content.contains(keyword)) return true;
  return false;
}

bool hasKeywordClubGathering(
    {required ClubGathering gathering, required String keyword}) {
  if (gathering.tagList.contains(keyword)) return true;
  if (gathering.detailCategory.contains(keyword)) return true;
  if (gathering.cityList.contains(keyword)) return true;
  if (gathering.title.contains(keyword)) return true;
  if (gathering.content.contains(keyword)) return true;
  return false;
}

List<OneDayGathering> getOneDayGatheringListByGatheringList(List gatheringList){
  List<OneDayGathering> result = [];
  for(var gathering in gatheringList){
    result.add(OneDayGathering.fromJson(gathering));
  }
  result.sort((OneDayGathering a, OneDayGathering b)=>DateTime.parse(b.openingDate).difference(DateTime.parse(a.openingDate)).inSeconds);
  return result;
}

List<ClubGathering> getClubGatheringListByGatheringList(List gatheringList){
  List<ClubGathering> result = [];
  for(var gathering in gatheringList){
    result.add(ClubGathering.fromJson(gathering));
  }
  return result;
}
