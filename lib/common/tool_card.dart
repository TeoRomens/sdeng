import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ToolCard extends StatelessWidget{
  const ToolCard({super.key, required this.asset, required this.title});

  final String asset;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          width: 2.5,
          color: Color(0xffd7d6ff),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      color: Colors.white,
      shadowColor: Colors.grey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 12, right: 10),
            child: SvgPicture.asset(
              asset,
              height: 75,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22
              ),
            ),
          )
        ],
      ),
    );
  }

}