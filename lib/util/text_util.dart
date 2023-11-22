class TextUtils {

  static String abbreviateK(int number) {
    if (number < 1000) {
      return number.toString();
    } else {
      return "${(number / 1000).toStringAsFixed(1)}K";
    }
  }
}