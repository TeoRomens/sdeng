class TextUtils {

  static String abbreviateK(int number) {
    if (number < 1000) {
      return number.toString();
    } else {
      return "${(number / 1000).toStringAsFixed(1)}K";
    }
  }

  static String toHumanReadable(DateTime? date) {
    if(date != null) return '${date.day}/${date.month}/${date.year}';
    return '';
  }
}