import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String untranslatedLanguage = 'English';
  String translatedLanguage = 'Russian';

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
    'Norwegian': 'nor',
    'Russian': 'ru',
    'Swedish': 'swe'
  };

  void translation(String language) async {
    String translated = "";

    //TODO: add language support for: English, German, French, Dutch, Norwegian, Russian, Swedish (æsj).
    final translator = GoogleTranslator();

    translator
        .translate(language,
            from: languageMap[untranslatedLanguage] ?? "",
            to: languageMap[translatedLanguage] ?? "")
        .then(
          (value) => translated = value.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    //Testing if translator works

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
            keyboardType: TextInputType.multiline,
            maxLines: 7,
            onChanged: (value) => print(value),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              hintText: "Hei",
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
            child: Text(translatedLanguage),
          ),
        ],
      ),
    );
  }
}
