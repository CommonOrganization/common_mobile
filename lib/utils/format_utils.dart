import 'package:intl/intl.dart';
import 'dart:math';
import '../constants/constants_enum.dart';

String getMoneyFormat(int price) {
  return NumberFormat('###,###,###,###').format(price);
}

String getCityNames(List<City> cityList) {
  String result = '';
  for (City city in cityList) {
    if (result.isEmpty) {
      result = city.name;
      continue;
    }
    result = '$result, ${city.name}';
  }
  return result;
}

String getCityNamesString(List cityList) {
  String result = '';
  for (String city in cityList) {
    if (result.isEmpty) {
      result = city;
      continue;
    }
    result = '$result, $city';
  }
  return result;
}

double getRadianFromDegree(double degree) {
  return degree * pi / 180;
}

String getTimeToWrite(String timeStamp){
  DateTime dateTime = DateTime.parse(timeStamp);
  DateTime nowDate = DateTime.now();
  Duration duration = nowDate.difference(dateTime);
  if(duration.inSeconds<60){
    return '${duration.inSeconds}초';
  }
  if(duration.inMinutes<60){
    return '${duration.inMinutes}분';
  }
  if(duration.inHours<60){
    return '${duration.inHours}시간';
  }
  if(duration.inDays<7){
    return '${duration.inDays}일';
  }
  if(duration.inDays<30){
    return '${duration.inDays~/7}주';
  }
  if(duration.inDays<365){
    return '${duration.inDays~/30}달';
  }
  return '${duration.inDays~/365}년';
}
