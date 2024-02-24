import 'package:flutter/material.dart';

class FiscalCodeUtils {

  DateTime? getDateOfBirthFromFiscalCode(String fiscalCode) {
    try {
      Map<String, int> month = {
        "A": 1,
        "B": 2,
        "C": 3,
        "D": 4,
        "E": 5,
        "H": 6,
        "L": 7,
        "M": 8,
        "P": 9,
        "R": 10,
        "S": 11,
        "T": 12
      };

      fiscalCode = fiscalCode.toUpperCase();

      String date = fiscalCode.substring(6, 11);
      int py = int.parse(date.substring(0, 2));
      String fy = (py < 9) ? "20$py" : "19$py";
      int y = int.parse(fy);
      int m = month[date.substring(2, 3)]!;
      int d = int.parse(date.substring(3, 5));

      if (d > 31) {
        d -= 40;
      }

      debugPrint('$d/$m/$y');
      return DateTime(y, m, d);
    } catch (e) {
      return null;
    }
  }

  final Map<String, String> codiciCatastali = {
    "A001": "Abano Terme",
  };
}