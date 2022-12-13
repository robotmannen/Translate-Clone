import 'package:flutter/material.dart';
import '../models/TranslationItem.dart';

class CurrentTranslationWidget extends StatefulWidget {

  final TranslationItem translationItem;
  final String translatedLanguage;
  final Function(bool) handleFavouriteOnPressed;

  const CurrentTranslationWidget({super.key,
    required this.translationItem,
    required this.translatedLanguage,
    required this.handleFavouriteOnPressed});

  @override
  State<CurrentTranslationWidget> createState() =>
      _CurrentTranslationWidgetState();
}

class _CurrentTranslationWidgetState extends State<CurrentTranslationWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: const BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.translatedLanguage,
                  style: const TextStyle(
                    color: Colors.white70,
                  )),
              IconButton(
                icon: Icon(
                    widget.translationItem.isFavourite
                        ? Icons.star
                        : Icons.star_outline
                ),
                color: Colors.white,
                onPressed: () {
                  widget.handleFavouriteOnPressed(
                      widget.translationItem.isFavourite);
                },
              ),
            ],
          ),
          Text(
            widget.translationItem.translated,
            style: const TextStyle(color: Colors.white, fontSize: 20.0),
          ),
          Text(widget.translationItem.untranslated)
        ],
      ),
    );
  }
}
