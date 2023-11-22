import 'package:flutter/material.dart';

class Credits extends StatelessWidget {
  const Credits({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Text(
                'Credits \n\n'
                'All the icons in the Sdeng app are provided by Icons8.com',
            style: TextStyle(
              fontFamily: 'Courier',
              color: Colors.black
            ),
            textAlign: TextAlign.center,
          )
        ),
      ),
    );
  }
}
