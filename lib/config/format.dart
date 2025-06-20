class Format {
  static String moneyFormat(int amount) {
    return '${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')} đ';
  }

  static String dateFormat(String date) {
    try {
      final dateTime = DateTime.parse(date);
      final hh = dateTime.hour.toString().padLeft(2, '0');
      final mm = dateTime.minute.toString().padLeft(2, '0');
      final ss = dateTime.second.toString().padLeft(2, '0');
      final dd = dateTime.day.toString().padLeft(2, '0');
      final MM = dateTime.month.toString().padLeft(2, '0');
      final yyyy = dateTime.year.toString();

      return '$hh:$mm:$ss $dd/$MM/$yyyy';
    } catch (e) {
      return '{Invalid date}';
    }
  }
}
