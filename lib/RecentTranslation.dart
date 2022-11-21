import 'dart:collection';

class RecentTranslation extends LinkedListEntry<RecentTranslation> {
  final String untranslated;
  final String translated;

  RecentTranslation(
      this.untranslated,
      this.translated
      );

  @override
  String toString() {
    return '$untranslated : $translated';
  }
}