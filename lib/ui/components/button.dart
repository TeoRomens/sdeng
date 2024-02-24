import 'package:flutter/material.dart';
import 'package:sdeng/utils/constants.dart';

class SdengPrimaryButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onPressed;

  const SdengPrimaryButton({super.key,
    required this.text,
    required this.onPressed,
    this.icon,
  });

  factory SdengPrimaryButton.icon({
    required String text,
    required IconData icon,
    required VoidCallback onPressed
  }) {
    return SdengPrimaryButton(
      text: text,
      icon: icon,
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(90, 44),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
            fontFamily: 'ProductSans',
            fontSize: 16.5,
            fontWeight: FontWeight.w700
        ),
        //minimumSize: const Size(100, 52),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(7)),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          icon != null ? Icon(icon, color: Colors.white,) : const SizedBox.shrink(),
          icon != null ? const SizedBox(width: 8) : const SizedBox.shrink(),
          Flexible(child: Text(text,))
        ],
      ),
    );
  }
}

class SdengDefaultButton extends StatelessWidget {
  final String text;
  final Widget? icon;
  final VoidCallback onPressed;

  const SdengDefaultButton({super.key, required this.text, required this.onPressed, this.icon});

  factory SdengDefaultButton.icon({required String text, required Widget icon, required VoidCallback onPressed}) {
    return SdengDefaultButton(
      text: text,
      icon: icon,
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(90, 44),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        foregroundColor: const Color(0xFF414141),
        textStyle: const TextStyle(
            fontFamily: 'ProductSans',
            fontSize: 16,
            fontWeight: FontWeight.bold
        ),
        //minimumSize: const Size(100, 52),
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            color: Color(0xffdedede),
            width: 0.8
          ),
          borderRadius: BorderRadius.all(Radius.circular(7)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16)
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          icon != null ? SizedBox(height: 26, width: 26, child: icon!) : const SizedBox.shrink(),
          icon != null ? const SizedBox(width: 8) : const SizedBox.shrink(),
          Flexible(child: Text(text,))
        ],
      ),
    );
  }
}
