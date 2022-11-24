import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

abstract class ListItem {
  Widget buildTitle(BuildContext context);
  Widget buildSubtitle(BuildContext context);
}

class TestItem implements ListItem {
  final String heading;

  TestItem({required this.heading});

  @override
  Widget buildSubtitle(BuildContext context) {
    return Text(
      heading,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }

  @override
  Widget buildTitle(BuildContext context) {
    // TODO: implement buildTitle
    throw UnimplementedError();
  }
}

class RecentTranslationItem {
  final Uuid id = const Uuid();
  final String untranslated;
  final String translated;
  final bool isFavourite = false;

  RecentTranslationItem(this.untranslated, this.translated);

  @override
  String toString() {
    return '$untranslated : $translated';
  }
}
