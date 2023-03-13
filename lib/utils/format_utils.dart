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
