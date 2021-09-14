import 'package:calculator/components/custom-button.dart';
import 'package:calculator/public/colors.dart';
import 'package:flutter/cupertino.dart';

class Button extends StatelessWidget {
  final String iconName;
  final String title;
  final void Function() onPressed;
  final bool iconRight;
  Button(
      {required this.iconName,
      required this.title,
      required this.onPressed,
      this.iconRight = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomButton(
        onPressed: onPressed,
        suffix: iconRight
            ? Container(
                padding: EdgeInsets.all(2),
                child: Image.asset('assets/images/$iconName.png'))
            : Container(),
        prefix: iconRight
            ? Container()
            : Container(
                padding: EdgeInsets.all(2),
                child: Image.asset('assets/images/$iconName.png')),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        text: title,
        backColor: mainColor,
        height: 32,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
