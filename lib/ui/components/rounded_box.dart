import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdeng/utils/constants.dart';

class RoundedBox2Values extends StatelessWidget{
  final String text;
  final int value;

  const RoundedBox2Values({super.key,
    required this.text,
    required this.value
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: shadowColor,
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ]
      ),
      width: MediaQuery.of(context).size.width * .43,
      height: MediaQuery.of(context).size.width * .36,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value.toString(),
                style: GoogleFonts.bebasNeue(
                    color: primaryColor,
                    fontSize: 65,
                    height: 1
                )),
            Text(text,
                style: const TextStyle(
                    fontSize: 20,
                    color: black2
                ))
          ],
        ),
      ),
    );
  }
}