class Utils {
  static String readTimestamp(int timestamp) {
    print("timestamp${timestamp}");
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    String time =
        '${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    if (date.hour == 0 && date.minute == 0) {
      time =
          '${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }
    return time;
  }
}
