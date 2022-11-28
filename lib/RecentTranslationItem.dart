
class RecentTranslationItem {
  final String untranslated;
  final String translated;
  late bool isFavourite;

  RecentTranslationItem(this.untranslated, this.translated, this.isFavourite);

  @override
  String toString() {
    return '$untranslated : $translated';
  }
}
