import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:translate_clone/RecentTranslation.dart';
import 'package:translator/translator.dart';
import 'package:easy_debounce/easy_debounce.dart';

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

  LinkedList<RecentTranslation> recentTranslationsLinkedList = LinkedList<RecentTranslation>();
  String untranslatedLanguage = 'English';
  String translatedLanguage = 'Russian';
  String translatedString = "";

  //List<String> recentTranslations = [];

  List<String> languageList = [
    'English',
    'German',
    'French',
    'Dutch',
    'Norwegian',
    'Russian',
    'Swedish'
  ];
  Map<String, String> languageMap = {
    'English': 'en',
    'German': 'de',
    'French': 'fr',
    'Dutch': 'nl',
    'Norwegian': 'no',
    'Russian': 'ru',
    'Swedish': 'sw'
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                recentTranslationsLinkedList.add(RecentTranslation(value, translatedString));
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
          DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(width: 1.0, color: Colors.grey),
            ),
            child: Text(translatedString),
          ),
        ],
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
        print(value.text);
        translatedString = value.text;
      });
    });
  }
}
