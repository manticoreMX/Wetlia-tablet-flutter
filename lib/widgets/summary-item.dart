import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SummaryItem extends StatelessWidget {
  final String title;
  final String value;
  SummaryItem({required this.title, required this.value});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              title,
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
              flex: 1,
              child: Text(
                value,
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
    );
  }
}
