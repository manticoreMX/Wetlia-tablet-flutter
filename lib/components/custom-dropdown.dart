import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDropdowHome extends StatefulWidget {
  final bool landscape;
  final String title;
  final List<String> items;
  final double height;
  final Function onChanged;
  CustomDropdowHome(
      {required this.landscape,
      this.title = '',
      required this.items,
      this.height = 30,
      required this.onChanged});
  @override
  CustomDropdownHomeState createState() => CustomDropdownHomeState();
}

class CustomDropdownHomeState extends State<CustomDropdowHome> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int? index = 0;
  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<int?>> ddItems = [];
    int i = 0;
    widget.items.forEach((element) {
      ddItems.add(DropdownMenuItem(
          child: Text(element, overflow: TextOverflow.ellipsis), value: i++));
    });
    Widget child = DropdownButtonHideUnderline(
        child: DropdownBelow(
            items: ddItems,
            boxDecoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 3, color: Colors.grey[800]!),
                borderRadius: BorderRadius.all(Radius.circular(100))),
            itemWidth: 180,
            itemTextstyle: TextStyle(fontSize: 12, color: Colors.black),
            boxTextstyle: TextStyle(fontSize: 10, color: Colors.black),
            boxPadding: EdgeInsets.only(left: 4),
            boxHeight: widget.height,
            boxWidth: 180,
            icon: Icon(Icons.expand_more_rounded, color: Colors.grey, size: 20),
            value: index,
            onChanged: (int? value) {
              setState(() => index = value);
              widget.onChanged(value);
            }));
    return Container(
      child: child,
    );
  }
}
