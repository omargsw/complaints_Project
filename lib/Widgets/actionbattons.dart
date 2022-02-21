import 'package:flutter/material.dart';

import 'colors.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;
  final double width;

  const ButtonWidget({
    required this.text,
    required this.onClicked,
    required this.width,
     Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(
    width: width,
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: RaisedButton(
        onPressed: onClicked,
        color: ColorForDesign().blue,
        child: Text(text,style: TextStyle(color: ColorForDesign().white),),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    ),
  );
}