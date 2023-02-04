String getDateFromDateTime(DateTime dateTime) {
  return '${dateTime.year}.${dateTime.month >= 10 ? dateTime.month : '0${dateTime.month}'}.${dateTime.day >= 10 ? dateTime.day : '0${dateTime.day}'}';
}

String getSimplyDateFromDateTime(DateTime dateTime) {
  return '${dateTime.year}.${dateTime.month}.${dateTime.day}.';
}