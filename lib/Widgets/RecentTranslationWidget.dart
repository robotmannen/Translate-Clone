import 'package:flutter/material.dart';
import 'package:translate_clone/DataTypes.dart';

class RecentTranslation extends StatelessWidget {

  final RecentTranslationItem recentTranslationItem;

  const RecentTranslation(
      {super.key,
      required this.recentTranslationItem});

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(recentTranslationItem.translated),
              Text(recentTranslationItem.untranslated)
            ],
          )),
    );
  }
}
