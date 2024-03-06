import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdeng/utils/constants.dart';

class MedicalBox extends StatelessWidget{
  final String text;
  final int value;
  final Color valueColor;

  const MedicalBox({super.key,
    required this.text,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: const Border(
            top: BorderSide(color: Color(0xffcccccc)),
            bottom: BorderSide(color: Color(0xffcccccc)),
            left: BorderSide(color: Color(0xffcccccc)),
            right: BorderSide(color: Color(0xffcccccc)),
          ),
      ),
      height: 64,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {

        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(text,
                style: const TextStyle(
                    fontSize: 20,
                    color: black2
                )),
              const Spacer(),
              Text(value.toString(),
                style: GoogleFonts.bebasNeue(
                    color: valueColor,
                    fontSize: 50,
                    height: 1.3
                )),
              spacer16,
              const Icon(FeatherIcons.chevronRight, size: 28,)
            ],
          ),
        ),
      ),
    );
  }
}