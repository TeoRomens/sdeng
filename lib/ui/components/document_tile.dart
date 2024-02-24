import 'package:flutter/material.dart';

class SdengDocumentTile extends StatelessWidget {
  final String docName;
  final VoidCallback onPressed;

  const SdengDocumentTile({super.key, required this.onPressed, required this.docName});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(200, 42),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        foregroundColor: const Color(0xFF414141),
        textStyle: const TextStyle(
            fontFamily: 'ProductSans',
            fontSize: 14,
            fontWeight: FontWeight.w700
        ),
        //minimumSize: const Size(100, 52),
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            color: Color(0xffdedede),
            width: 0.8
          ),
          borderRadius: BorderRadius.all(Radius.circular(7)),
        ),
        padding: const EdgeInsets.only(right: 4, left: 16)
      ),
      child: Row(
        children: <Widget>[
          const CircleAvatar(
            maxRadius: 17,
            backgroundColor: Color(0xffeaeffd),
            child: Icon(Icons.file_present_rounded,
              color: Color(0xff3c81f6),
              size: 22,
            )
          ),
          const SizedBox(width: 12,),
          Text(docName),
          const Spacer(),
          IconButton(
              onPressed: onPressed,
              icon: const SizedBox(
                child: Icon(Icons.document_scanner),
              )
          ),
        ],
      ),
    );
  }
}
