import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

/// Simple preloader inside a Center widget
final preloader = Center(
  child: SizedBox(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset('assets/logos/SDENG_logo.svg', height: 40, color: Colors.white,),
        Lottie.asset(
          'assets/animations/loading.json', height: 100
        ),
      ],
    ),
  ),
);

/// Simple shimmer inside SafeArea and ListView
final shimmerLoader = Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: SafeArea(
      minimum: const EdgeInsets.all(15),
      child: ListView.builder(
          itemCount: 8,
          itemBuilder: ((context, index) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(5, 8, 5, 8),
              child:
              Container(
                height: 70,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white
                ),
              ),
            );
          }),
      )
    ),
  );

/// Simple sized box to space out form elements
const spacer16 = SizedBox(width: 16, height: 16);

/// Some padding for all the forms to use
const formPadding = EdgeInsets.symmetric(vertical: 20, horizontal: 16);

/// Error message to display the user when unexpected error occurs.
const unexpectedErrorMessage = 'Unexpected error occurred.';

/// Set of extension methods to easily display a snack bar
extension ShowSnackBar on BuildContext {
  /// Displays a basic white snack bar
  void showSnackBar({
    required String message,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
      )
    );
  }

  /// Displays a red snack bar indicating error
  void showErrorSnackBar({required String message}) {
    ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        )
    );
  }

  /// Displays a green snack bar indicating error
  void showSuccessSnackBar({required String message}) {
    ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
        )
    );
  }
}

/// Size of each markers on a map
const defaultMarkerSize = 75.0;

/// Width of the border of markers on maps
const borderWidth = 5.0;

const Color primaryDarkColor2 = Color(0xff360568);
const Color primaryDarkColor = Color(0xff3C149E);
const Color primaryColor = Color(0xff561de2);
const Color primaryLightColor = Color(0xff9381FF);
const Color primaryLightColor2 = Color(0xffB8B8FF);

const Color shadowColor = Color(0xFFe5e8eb);
const Color greenColor = Color(0xFF44CF6C);
const Color backgroundColor = Color(0xF8F9FAFF);

const Color black1 = Color(0xFF1e1e1e);
const Color black2 = Color(0xff323232);

const Color lightGreyColor = Color(0xFFF1F1F1);

/// Utility method to convert timestamp to human readable text.
String howLongAgo(DateTime time, {DateTime? seed}) {
  final now = seed ?? DateTime.now();
  final difference = now.difference(time);
  if (difference < const Duration(minutes: 1)) {
    return 'now';
  } else if (difference < const Duration(hours: 1)) {
    return '${difference.inMinutes}m';
  } else if (difference < const Duration(days: 1)) {
    return '${difference.inHours}h';
  } else if (difference < const Duration(days: 30)) {
    return '${difference.inDays}d';
  } else if (now.year == time.year) {
    return '${time.month < 10 ? '0' : ''}${time.month}-'
        '${time.day < 10 ? '0' : ''}${time.day}';
  } else {
    return '${time.year}-${time.month < 10 ? '0' : ''}'
        '${time.month}-${time.day < 10 ? '0' : ''}${time.day}';
  }
}