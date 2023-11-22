import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MessageUtil {
  static CancelFunc? loadingCancelFunc;

  static void showMessage(String message) {
    BotToast.showCustomNotification(
        toastBuilder: (context) => _CustomMessage(message: message),
        duration: const Duration(seconds: 3),
        align: const Alignment(0, 0.99),
        enableSlideOff: false,
    );
  }

  static void showError(String message) {
    BotToast.showCustomNotification(
        toastBuilder: (context) => _CustomError(errorMessage: message,),
        duration: const Duration(seconds: 3),
        align: const Alignment(0, 0.99),
        enableSlideOff: false,
    );
  }

  static void showLoading() {
    loadingCancelFunc ??= BotToast.showCustomLoading(
          backgroundColor: Colors.black.withOpacity(.3),
          toastBuilder: (context) => const _LoaderOverlay());
  }

  static void hideLoading() {
    if (loadingCancelFunc != null) {
      loadingCancelFunc!();
      loadingCancelFunc = null;
    }
  }
}

class _LoaderOverlay extends StatelessWidget {
  const _LoaderOverlay();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
          width: 120,
          height: 120,
          child: Lottie.asset(
            'assets/animations/loading.json',
          ),),
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