import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:myjarvis/pallete.dart';

class featureBox extends StatelessWidget {
  final Color? color;
  final String headertext;
  final String descriptionText;
  const featureBox({super.key, this.color, required this.headertext, required this.descriptionText});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            headertext,
            style: TextStyle(color: Pallete.mainFontColor, fontSize: 15, fontFamily: 'ceraPro', fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 3,
          ),
          Text(
            descriptionText,
            style: TextStyle(color: Pallete.mainFontColor, fontSize: 12, fontFamily: 'ceraPro'),
          )
        ],
      ),
    );
  }
}
