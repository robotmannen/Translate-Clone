import 'package:flutter/material.dart';

class RecentTranslation extends StatelessWidget {
  final String header;

  RecentTranslation(this.header);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              border: Border.all(width: 1, color: Colors.black)),
          padding: const EdgeInsets.all(15.0),
          child: Text(header)),
    );
  }
}
