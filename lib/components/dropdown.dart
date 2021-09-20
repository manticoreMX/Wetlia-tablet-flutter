import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final bool landscape;
  final String title;
  final List<String> items;
  final Function onChanged;
  final int value;
  CustomDropdown(
      {required this.landscape,
      this.title = '',
      required this.items,
      required this.onChanged,
      this.value = 0});
  @override
  CustomDropdownState createState() => CustomDropdownState();
}

class CustomDropdownState extends State<CustomDropdown> {
  @override
  void initState() {
    super.initState();
    index = widget.value;
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
    List<Widget> children = [
      Text(
        widget.title,
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
      ),
      widget.landscape ? SizedBox(width: 12) : SizedBox(height: 12),
      DropdownButtonHideUnderline(
        child: DropdownBelow(
            items: ddItems,
            boxDecoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border.all(width: 1, color: Colors.grey)),
            itemWidth: 320,
            itemTextstyle: TextStyle(fontSize: 14, color: Colors.black),
            boxTextstyle: TextStyle(fontSize: 14, color: Colors.black),
            boxPadding: EdgeInsets.symmetric(horizontal: 12),
            boxHeight: 32,
            boxWidth: 180,
            icon: Icon(Icons.expand_more_rounded, color: Colors.grey, size: 20),
            value: index!,
            onChanged: (int? value) {
              setState(() => index = value);
              widget.onChanged(value);
            }),
      )
    ];
    return Container(
      child: widget.landscape
          ? Row(
              children: children,
            )
          : Column(
              children: children,
            ),
    );
  }
}
