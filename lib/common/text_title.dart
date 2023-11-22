import 'package:flutter/material.dart';

class TextTitle extends StatelessWidget {
  const TextTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22
          ),
        ),
      ),
    );
  }
}