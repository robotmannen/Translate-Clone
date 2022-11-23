import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:translate_clone/DataTypes.dart';
import 'package:translate_clone/Widgets/RecentTranslationWidget.dart';
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

  LinkedList<RecentTranslationItem> recentTranslationsLinkedList =
      LinkedList<RecentTranslationItem>();

  String untranslatedLanguage = 'English';
  String translatedLanguage = 'Russian';
  String translatedString = "";

  List<String> languageList = [
    'English',
    'German',
    'French',
    'Dutch',
    'Norwegian',
    'Russian',
    'Swedish',
    'Icelandic',
    'Spanish'
  ];
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

  final items = List<ListItem>.generate(10, (i) => TestItem(heading: "Header"));
  final test = List<String>.generate(10, (index) => "Hello $index");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: GoogleFonts.actor(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DropdownButton(
                    value: untranslatedLanguage,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: languageList.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        untranslatedLanguage = newValue!;
                        recentTranslationsLinkedList
                            .add(RecentTranslationItem("hei", "på deg"));
                        print(recentTranslationsLinkedList.first);
                      });
                    },
                  ),

                  // Swaps the two selected languages
                  IconButton(
                    icon: const Icon(Icons.rotate_left_rounded),
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
                    value: translatedLanguage,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: languageList.map((String items) {
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
                  recentTranslationsLinkedList
                      .add(RecentTranslationItem(value, translatedString));
                });
              }),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintText: "Write something ...",
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const Divider(),
            Container(
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
                      Text(translatedLanguage,
                          style: const TextStyle(color: Colors.white70)),
                      IconButton(
                        icon:
                            const Icon(Icons.star_outline, color: Colors.white),
                        onPressed: () => print('favourited'),
                      ),
                    ],
                  ),
                  Text(translatedString,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 20.0))
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return RecentTranslation("Header $index");
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void _debouncer(String query) {
    EasyDebounce.debounce('translation-debouncer',
        const Duration(milliseconds: 500), () => _translation(query));
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
