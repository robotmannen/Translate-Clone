import 'package:flutter/material.dart';
import 'package:translate_clone/RecentTranslationItem.dart';
import 'package:translate_clone/Widgets/CurrentTranslation.dart';
import 'package:translate_clone/Widgets/RecentTranslation.dart';
import 'package:translator/translator.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Translate',
      theme: ThemeData(
          primarySwatch: Colors.blue, scaffoldBackgroundColor: Colors.white),
      home: const MyHomePage(title: 'Google Translator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final translator = GoogleTranslator();

  List<RecentTranslationItem> recentTranslations = [];
  String untranslatedLanguage = 'English';
  String translatedLanguage = 'Russian';
  String untranslatedString = "";
  String translatedString = "";

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
                translatedString: translatedString,
                translatedLanguage: translatedLanguage,
                untranslatedString: untranslatedString,
              ),
            ),
            Visibility(
              visible: translatedString.isNotEmpty,
              child: const Divider(),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: recentTranslations.length,
                itemBuilder: (context, index) {
                  return RecentTranslation(
                    recentTranslationItem: recentTranslations[index],
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
    var result = recentTranslations.where((element) =>
        element.translated == translatedString &&
        element.untranslated == untranslatedString);

    if (result.isEmpty) {
      recentTranslations
          .add(RecentTranslationItem(value.trim(), translatedString, false));
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
            from: languageMap[untranslatedLanguage] ?? "",
            to: languageMap[translatedLanguage] ?? "")
        .then((value) {
      setState(() {
        translatedString = value.text;
      });
    });
  }
}
