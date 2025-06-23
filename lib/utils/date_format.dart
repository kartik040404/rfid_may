class DateHelper {
  static String formatToDDMMYYYY(String isoDate) {
    final DateTime dateTime = DateTime.parse(isoDate);
    final String day = dateTime.day.toString().padLeft(2, '0');
    final String month = dateTime.month.toString().padLeft(2, '0');
    final String year = dateTime.year.toString();
    return "$day/$month/$year";
  }
}
