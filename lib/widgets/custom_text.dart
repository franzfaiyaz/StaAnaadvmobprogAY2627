import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;

  const CustomText(this.text, {super.key, this.style, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.start,
      style:
          style ??
          const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontFamily: 'Poppins',
          ),
    );
  }
}
