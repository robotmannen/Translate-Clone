import 'dart:collection';

import 'package:uuid/uuid.dart';

class RecentTranslation extends LinkedListEntry<RecentTranslation> {
  final Uuid id;
  final String untranslated;
  final String translated;

  RecentTranslation(
      this.id,
      this.untranslated,
      this.translated
      );

  @override
  String toString() {
    return '$untranslated : $translated';
  }
}