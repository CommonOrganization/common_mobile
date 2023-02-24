import 'package:intl/intl.dart';

String getMoneyFormat(int price) {
  return NumberFormat('###,###,###,###').format(price);
}