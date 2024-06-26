import 'package:common/constants/constants_value.dart';

String getDateFromDateTime(DateTime dateTime) {
  return '${dateTime.year}년 ${dateTime.month}월 ${dateTime.day}일';
}

String getSimplyDateFromDateTime(DateTime dateTime) {
  return '${dateTime.year}.${dateTime.month}.${dateTime.day}.';
}

String getDateDetail(String date) {
  DateTime dateTime = DateTime.parse(date);
  return '${dateTime.month}월 ${dateTime.day}일 ${kWeekdayList[dateTime.weekday-1]} ${dateTime.hour >= 12 ? '오후' : '오전'} ${dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
}

String getSimplyDateDetail(String date) {
  DateTime dateTime = DateTime.parse(date);
  return '${dateTime.month}월 ${dateTime.day}일 ${dateTime.hour >= 12 ? '오후' : '오전'} ${dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
}

String getTimeDifference(DateTime dateTime) {
  DateTime nowDate = DateTime.now();
  if (nowDate.difference(dateTime).inSeconds < 60) {
    return '${nowDate.difference(dateTime).inSeconds}초 전';
  }
  if (nowDate.difference(dateTime).inMinutes < 60) {
    return '${nowDate.difference(dateTime).inMinutes}분 전';
  }
  if (nowDate.difference(dateTime).inHours < 24) {
    return '${nowDate.difference(dateTime).inHours}시간 전';
  }
  if (nowDate.difference(dateTime).inDays < 30) {
    return '${nowDate.difference(dateTime).inDays}일 전';
  }
  if (nowDate.difference(dateTime).inDays < 365) {
    return '${nowDate.difference(dateTime).inDays ~/ 30}달 전';
  }
  return '${nowDate.difference(dateTime).inDays ~/ 365}년 전';
}
