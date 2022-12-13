import 'package:flutter/material.dart';
import 'package:translate_clone/models/TranslationItem.dart';

class RecentTranslationWidget extends StatefulWidget {
  final TranslationItem translationItem;
  final Function(bool) handleFavouriteOnPressed;

  const RecentTranslationWidget({super.key,
    required this.translationItem,
    required this.handleFavouriteOnPressed});

  @override
  State<StatefulWidget> createState() => _RecentTranslationWidgetState();
}

class _RecentTranslationWidgetState extends State<RecentTranslationWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: const BoxDecoration(
        shape: BoxShape.rectangle,
      ),
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.translationItem.translated),
              IconButton(
                  onPressed: () {
                    setState(() {
                      widget.translationItem.isFavourite =
                      !widget.translationItem.isFavourite;

                      widget.handleFavouriteOnPressed(
                          widget.translationItem.isFavourite);
                    });
                  },
                  icon: Icon(widget.translationItem.isFavourite
                      ? Icons.star
                      : Icons.star_outline))
            ],
          ),
          Text(widget.translationItem.untranslated)
        ],
      ),
    );
  }
}
