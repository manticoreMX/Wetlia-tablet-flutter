import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInputField extends StatefulWidget {
  final TextEditingController controller;
  final String placeHolder;
  final String labelText;
  final TextInputType textInputType;
  final int lines;
  final bool autoFocus;
  final Widget? prefixIcon;
  final bool enabled;
  final Widget? suffixIcon;
  final bool obscureText;
  final Color borderColor;
  final Color backColor;
  final bool readOnly;
  final double height;
  final Alignment alignment;
  final double paddingTop;
  final bool underline;
  final double borderRadius;
  final Color underlineColor;
  final Color placeHolderColor;
  final Color textColor;
  final Color labelColor;
  final double paddingLeft;
  final bool bold;
  final double fontSize;
  final bool border;
  final double? borderWidth;
  final TextAlign textAlign;
  final void Function(String)? onChanged;
  CustomInputField(
      {Key? key,
      this.placeHolder = '',
      required this.controller,
      this.labelText = '',
      this.textInputType = TextInputType.text,
      this.lines = 1,
      this.autoFocus = false,
      this.prefixIcon,
      this.enabled = true,
      this.suffixIcon,
      this.borderColor = Colors.grey,
      this.backColor = Colors.transparent,
      this.readOnly = false,
      this.alignment = Alignment.center,
      this.height = 58.0,
      this.paddingTop = 6,
      this.obscureText = false,
      this.underlineColor = Colors.white,
      this.underline = true,
      this.placeHolderColor = Colors.grey,
      this.textColor = Colors.black,
      this.labelColor = Colors.grey,
      this.paddingLeft = 20.0,
      this.bold = false,
      this.borderWidth = 2.5,
      this.fontSize = 16.0,
      this.border = true,
      this.borderRadius = 100.0,
      this.textAlign = TextAlign.left,
      this.onChanged})
      : super(key: key);

  _CustomInputFieldState createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  var outlineBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(24.0)),
      borderSide: BorderSide(
        color: Colors.transparent,
      ));
  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.height,
        alignment: widget.alignment,
        decoration: BoxDecoration(
          color: widget.backColor,
          borderRadius: widget.border
              ? BorderRadius.all(Radius.circular(widget.borderRadius))
              : widget.underline
                  ? null
                  : BorderRadius.all(Radius.circular(widget.borderRadius)),
          border: widget.border
              ? Border.all(
                  width: widget.borderWidth!, color: widget.borderColor)
              : widget.underline
                  ? Border(
                      bottom: BorderSide(
                          color: widget.underline
                              ? widget.underlineColor
                              : Colors.transparent,
                          width: widget.borderWidth!))
                  : null,
        ),
        padding: EdgeInsets.only(
          left: widget.paddingLeft,
          right: 0,
          top: widget.paddingTop,
          bottom: widget.paddingTop,
        ),
        child: TextFormField(
          textAlignVertical: TextAlignVertical.center,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          controller: widget.controller,
          maxLines: widget.lines,
          autocorrect: false,
          autofocus: widget.autoFocus,
          keyboardType: widget.textInputType,
          cursorColor: Colors.grey,
          obscureText: widget.obscureText,
          textAlign: widget.textAlign,
          onChanged: widget.onChanged,
          style: TextStyle(
              color: widget.textColor,
              fontWeight: widget.bold ? FontWeight.bold : FontWeight.normal,
              fontSize: widget.fontSize),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(0),
              // prefixIcon: widget.prefixIcon,
              border: outlineBorder,
              focusedBorder: outlineBorder,
              enabledBorder: outlineBorder,
              disabledBorder: new UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              // suffixIcon: widget.suffixIcon,
              hintStyle:
                  TextStyle(color: widget.placeHolderColor, fontSize: 14.0),
              hintText: widget.placeHolder,
              labelStyle: TextStyle(color: widget.labelColor),
              labelText: widget.labelText),
        ));
  }
}
