/// Global variables used in the entire application.
/// Major are stored online and loaded during the starting
/// Others are stored locally using SharedPreferences and loaded during the starting
class Variables {
  static String uid = '';
  static String calendarId = '';
  static bool biometrics = false;

  static int quotaUnder = 0;
  static int primaRata = 0;
  static int secondaRata = quotaUnder - primaRata;
  static String societyName = '';

  static DateTime firstPaymentDate = DateTime(2023, DateTime.june, 1);
  static DateTime secondPaymentDate = DateTime(2024, DateTime.february, 1);

  static void clear() {
    uid = '';
    calendarId = '';
    quotaUnder = 0;
    primaRata = 0;
    societyName = '';
    firstPaymentDate = DateTime.now();
    secondPaymentDate = DateTime.now();
  }

}