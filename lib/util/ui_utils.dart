import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class UIUtils {

  static void showMessage(String message) {
    Get.snackbar(
      'Message',
      message,
      isDismissible: false,
      icon: const Icon(Icons.info_outlined, color: Colors.white,),
      shouldIconPulse: false,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      animationDuration: const Duration(milliseconds: 400),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      maxWidth: 500
    );
  }

  static void showError(String message) {
    Get.snackbar(
      'Error',
      message,
      isDismissible: false,
      icon: const Icon(Icons.error_outline_outlined, color: Colors.white,),
      shouldIconPulse: false,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      animationDuration: const Duration(milliseconds: 400),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      maxWidth: 500
    );
  }

  static Future awaitLoading(Future asyncFunction) async {
    return Get.showOverlay(
      asyncFunction: () => asyncFunction,
      loadingWidget: Center(
        child: SizedBox(
          width: 120,
          height: 120,
          child: Lottie.asset(
            'assets/animations/loading.json',
          ),),
      ),
    );
  }
}

class _CustomMessage extends StatelessWidget {
  final String message;

  const _CustomMessage({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFF23BB00),
          borderRadius: BorderRadius.circular(10)),
      width: double.infinity,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      constraints: const BoxConstraints(
          maxWidth: 400
      ),
      child: Row(
        children: [
          const Icon(Icons.info, color: Colors.white,),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomError extends StatelessWidget {
  const _CustomError({
    required this.errorMessage
  });

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10)),
      width: double.infinity,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      constraints: const BoxConstraints(
        maxWidth: 400
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              errorMessage,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}