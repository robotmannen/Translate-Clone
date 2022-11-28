import 'package:flutter/material.dart';

class CurrentTranslationWidget extends StatefulWidget {
  String translatedLanguage;
  String untranslatedString;
  String translatedString;

  CurrentTranslationWidget(
      {super.key,
      required this.translatedLanguage,
      required this.untranslatedString,
      required this.translatedString});

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
                icon: const Icon(
                  Icons.star_outline,
                ),
                color: Colors.white,
                onPressed: () => print('favourited'),
              ),
            ],
          ),
          Text(
            widget.translatedString,
            style: const TextStyle(color: Colors.white, fontSize: 20.0),
          ),
          Text(widget.untranslatedString)
        ],
      ),
    );
  }
}
