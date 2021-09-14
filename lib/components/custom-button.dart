import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final void Function() onPressed;
  final Color textColor;
  final Color backColor;
  final double fontSize;
  final double width;
  final double margin;
  final double height;
  final double borderRadius;
  final double borderWidth;
  final Color borderColor;
  final FontWeight fontWeight;
  final Widget? prefix;
  final Widget? suffix;
  final MainAxisAlignment mainAxisAlignment;
  CustomButton(
      {this.text = '',
      required this.onPressed,
      this.textColor = Colors.white,
      this.backColor = Colors.transparent,
      this.fontSize = 13.0,
      this.width = 140,
      this.margin = 4.0,
      this.height = 40.0,
      this.borderRadius = 80.0,
      this.borderWidth = 0.0,
      this.borderColor = Colors.transparent,
      this.fontWeight = FontWeight.normal,
      this.prefix,
      this.suffix,
      this.mainAxisAlignment = MainAxisAlignment.center});

  CustomButtonState createState() => CustomButtonState();
}

class CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    if (widget.width == 0)
      return Container(
        height: widget.height,
        margin: EdgeInsets.symmetric(horizontal: widget.margin),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: widget.backColor,
                elevation: 0,
                padding: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: widget.borderColor, width: widget.borderWidth),
                    borderRadius: BorderRadius.circular(widget.borderRadius))),
            onPressed: widget.onPressed,
            child: Container(
                child: Row(
              mainAxisAlignment: widget.mainAxisAlignment,
              children: [
                widget.prefix == null ? Container(width: 0) : widget.prefix!,
                SizedBox(width: 10),
                Text(
                  widget.text,
                  style: TextStyle(
                      color: widget.textColor,
                      fontWeight: widget.fontWeight,
                      fontSize: widget.fontSize),
                ),
                SizedBox(width: 10),
                widget.suffix == null ? Container(width: 0) : widget.suffix!
              ],
            ))),
      );
    else
      return Container(
        height: widget.height,
        width: widget.width,
        margin: EdgeInsets.symmetric(horizontal: widget.margin),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: widget.backColor,
                elevation: 0,
                padding: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius))),
            onPressed: widget.onPressed,
            child: Container(
                child: Row(
              mainAxisAlignment: widget.mainAxisAlignment,
              children: [
                widget.prefix == null ? Container(width: 0) : widget.prefix!,
                SizedBox(width: 10),
                Text(
                  widget.text,
                  style: TextStyle(
                      color: widget.textColor,
                      fontWeight: widget.fontWeight,
                      fontSize: widget.fontSize),
                ),
                SizedBox(width: 10),
                widget.suffix == null ? Container(width: 0) : widget.suffix!
              ],
            ))),
      );
  }
}
