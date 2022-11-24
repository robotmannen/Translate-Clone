import 'package:flutter/material.dart';
import 'package:translate_clone/RecentTranslationItem.dart';

class RecentTranslation extends StatefulWidget {
  RecentTranslationItem recentTranslationItem;

  RecentTranslation({super.key, required this.recentTranslationItem});

  @override
  State<StatefulWidget> createState() => _RecentTranslationState();
}

class _RecentTranslationState extends State<RecentTranslation> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
          width: double.maxFinite,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
          ),
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.recentTranslationItem.translated),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          if (!widget.recentTranslationItem.isFavourite) {
                            widget.recentTranslationItem.isFavourite = true;
                          } else {
                            widget.recentTranslationItem.isFavourite = false;
                          }
                        });
                      },
                      icon: Icon(widget.recentTranslationItem.isFavourite
                          ? Icons.star
                          : Icons.star_outline))
                ],
              ),
              Text(widget.recentTranslationItem.untranslated)
            ],
          )),
    );
  }
}
