import 'package:intl/intl.dart';

extension DateTimeTimeExtension on DateTime {
  bool isSameDate(DateTime inputDate) {
    return year == inputDate.year &&
        month == inputDate.month &&
        day == inputDate.day;
  }
}

class DateUtil {
  static DateTime tomorrow() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day + 1);
  }

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final dateToCheck = DateTime(date.year, date.month, date.day);

    if (dateToCheck == today) return true;
    return false;
  }

  static bool isYesterday(DateTime date) {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    final dateToCheck = DateTime(date.year, date.month, date.day);

    if (dateToCheck == yesterday) return true;
    return false;
  }

  static String hMMFormat(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  static String dateWithDayFormat(DateTime dateTime) {
    final weekName = _weekNames()[dateTime.weekday];
    final date = DateFormat('yMMMMd').format(dateTime);
    return '$date ($weekName)';
  }

  static String dateWithSlashFormat(DateTime dateTime) {
    return DateFormat("dd/MM/yyyy").format(dateTime);
  }

  static List<String> _weekNames() {
    return <String>[
      '',
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];
  }
}
