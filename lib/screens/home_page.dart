import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translate_clone/models/TranslationItem.dart';
import 'package:translate_clone/Widgets/CurrentTranslationWidget.dart';
import 'package:translate_clone/Widgets/RecentTranslationWidget.dart';
import 'package:translate_clone/globals.dart';
import 'package:translator/translator.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:google_fonts/google_fonts.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final translator = GoogleTranslator();

  List<TranslationItem> _recentTranslations = [];
  late String untranslatedLanguage;
  late String translatedLanguage;
  late String untranslatedString;
  late String translatedString;

  Map<String, String> languageMap = {
    'English': 'en',
    'German': 'de',
    'French': 'fr',
    'Dutch': 'nl',
    'Norwegian': 'no',
    'Russian': 'ru',
    'Swedish': 'sv',
    'Icelandic': 'is',
    'Spanish': 'es'
  };

  @override
  void initState() {
    super.initState();
    _loadPrefs();
    untranslatedLanguage = 'English';
    translatedLanguage = 'Russian';
    untranslatedString = "";
    translatedString = "";
  }

  _setPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final String encodedTranslations =
        TranslationItem.encode(_recentTranslations);
    prefs.setString(TRANSLATIONS_KEY, encodedTranslations);
  }

  _loadPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? translationsString = prefs.getString(TRANSLATIONS_KEY);
    final List<TranslationItem> recentTranslationsPrefs =
        TranslationItem.decode(translationsString!);
    setState(() {
      _recentTranslations = recentTranslationsPrefs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffededed),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title,
          style: GoogleFonts.aBeeZee(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton(
                  isExpanded: false,
                  value: untranslatedLanguage,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: languageMap.keys.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      untranslatedLanguage = newValue!;
                    });
                  },
                ),
                // Swaps the two selected languages
                IconButton(
                  icon: const Icon(Icons.swap_horiz_rounded),
                  onPressed: () {
                    String temp;
                    setState(() {
                      temp = translatedLanguage;
                      translatedLanguage = untranslatedLanguage;
                      untranslatedLanguage = temp;
                    });
                  },
                ),
                DropdownButton(
                  isExpanded: false,
                  value: translatedLanguage,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: languageMap.keys.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      translatedLanguage = newValue!;
                    });
                  },
                ),
              ],
            ),
            const Divider(),
            TextField(
              textInputAction: TextInputAction.go,
              keyboardType: TextInputType.multiline,
              maxLines: 7,
              onChanged: (value) {
                _debouncer(value);
              },
              onSubmitted: ((value) {
                setState(() {
                  _addToRecentTranslations(value);
                });
              }),
              decoration: InputDecoration(
                enabledBorder: InputBorder.none,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintText: "Write something ...",
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const Divider(),
            Visibility(
              visible: translatedString.isNotEmpty,
              child: CurrentTranslationWidget(
                translationItem: TranslationItem(
                    untranslated: untranslatedString,
                    translated: translatedString,
                    isFavourite: _recentTranslations.contains(
                      TranslationItem(
                          untranslated: untranslatedString,
                          translated: translatedString,
                          isFavourite: true),
                    )),
                translatedLanguage: translatedLanguage,
                handleFavouriteOnPressed: (p0) {
                  //TODO: handle favourite onPressed
                },
              ),
            ),
            Visibility(
              visible: translatedString.isNotEmpty,
              child: const Divider(),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _recentTranslations.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    background: Container(color: Colors.red),
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      _recentTranslations.removeAt(index);
                      _setPrefs();
                    },
                    child: RecentTranslationWidget(
                      translationItem: _recentTranslations[index],
                      handleFavouriteOnPressed: (p0) {
                        setState(() {
                          _recentTranslations[index].isFavourite = p0;
                          _setPrefs();
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addToRecentTranslations(String value) {
    var result = _recentTranslations.where((element) =>
        element.translated == translatedString &&
        element.untranslated == untranslatedString);

    if (result.isEmpty) {
      _recentTranslations.add(TranslationItem(
          untranslated: value.trim(),
          translated: translatedString,
          isFavourite: false));
      _setPrefs();
    }
  }

  void _debouncer(String query) {
    EasyDebounce.debounce(
        'translation_debouncer', const Duration(milliseconds: 500), () {
      _translation(query);
      untranslatedString = query;
    });
  }

  void _translation(String input) async {
    if (input == "") {
      setState(() {
        translatedString = "";
      });
    }
    translator
        .translate(input,
            from: languageMap[untranslatedLanguage] ?? "en",
            to: languageMap[translatedLanguage] ?? "ru")
        .then((value) {
      setState(() {
        translatedString = value.text;
      });
    });
  }
}
