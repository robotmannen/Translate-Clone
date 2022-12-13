import 'dart:convert';

class TranslationItem {
  final String untranslated;
  final String translated;
  late bool isFavourite;

  TranslationItem(
      {required this.untranslated,
      required this.translated,
      required this.isFavourite});

  @override
  String toString() {
    return '$untranslated : $translated';
  }

  factory TranslationItem.fromJson(Map<String, dynamic> json) =>
      TranslationItem(
          untranslated: json["untranslated"],
          translated: json["translated"],
          isFavourite: json["isFavourite"]);

  Map<String, dynamic> toJson() => {
        "untranslated": untranslated,
        "translated": translated,
        "isFavourite": isFavourite
      };

  static Map<String, dynamic> toMap(TranslationItem translationItem) => {
        'untranslated': translationItem.untranslated,
        'translated': translationItem.translated,
        'isFavourite': translationItem.isFavourite
      };

  static String encode(List<TranslationItem> translationItems) => json.encode(
        translationItems
            .map<Map<String, dynamic>>(
                (translationItem) => TranslationItem.toMap(translationItem))
            .toList(),
      );

  static List<TranslationItem> decode(String translationItems) =>
      (json.decode(translationItems) as List<dynamic>)
          .map<TranslationItem>((item) => TranslationItem.fromJson(item))
          .toList();
}
