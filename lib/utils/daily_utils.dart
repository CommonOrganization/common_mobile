import 'package:common/models/daily/daily.dart';

bool hasKeywordDaily(
    {required Daily daily, required String keyword}) {
  if (daily.tagList.contains(keyword)) return true;
  if (daily.detailCategory.contains(keyword)) return true;
  if (daily.content.contains(keyword)) return true;
  return false;
}

String getCommentId({required String dailyId}){
  return '${dailyId}_comment_${DateTime.now().microsecondsSinceEpoch}';
}

String getReplyId({required String dailyId,required String commentId}){
  return '${dailyId}_${commentId}_reply_${DateTime.now().microsecondsSinceEpoch}';
}
