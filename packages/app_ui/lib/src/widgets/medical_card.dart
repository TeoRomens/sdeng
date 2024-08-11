import 'package:flutter/material.dart';

class MedicalCard extends StatelessWidget {
  const MedicalCard({
    super.key,
    required this.title,
    required this.num,
    required this.image,
    this.action,
  });

  final String title;
  final int num;
  final Widget image;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(
          color: Color(0xFFE4E7EC),
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    letterSpacing: -0.02,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$num',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 6),
                    action ?? const SizedBox.shrink(),
                  ],
                ),
                SizedBox(
                  width: 80,
                  height: 80,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: image,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
