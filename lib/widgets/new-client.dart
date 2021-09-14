import 'package:calculator/components/custom-button.dart';
import 'package:calculator/components/custom-input.dart';
import 'package:calculator/public/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewClient extends StatelessWidget {
  final void Function(String) onPressed;
  NewClient({required this.onPressed});
  final TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: EdgeInsets.symmetric(horizontal: 36, vertical: 24),
      decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'Nuevo Cliente',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          Container(
            height: 36,
            child: CustomInputField(
                controller: _controller,
                textAlign: TextAlign.center,
                backColor: Colors.white,
                borderColor: Colors.white,
                paddingLeft: 0,
                onChanged: (value) {},
                height: 36),
          ),
          CustomButton(
            onPressed: () {
              Navigator.pop(context);
              onPressed(_controller.text);
            },
            text: 'Crear',
            width: 160,
            backColor: mainColor,
            textColor: Colors.white,
            fontSize: 20,
            height: 32,
          )
        ],
      ),
    );
  }
}
