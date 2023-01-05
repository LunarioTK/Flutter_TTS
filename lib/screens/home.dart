import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FlutterTts flutterTts = FlutterTts();
  @override
  void initState() {
    super.initState();
    flutterTTSInit();
  }

  flutterTTSInit() async {
    await flutterTts.setLanguage('pt-PT');
    await flutterTts.isLanguageAvailable("pt-PT");
    await flutterTts.setVoice({"name": "Karen", "locale": "en-AU"});
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Text To Speech App'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue.shade800,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Text',
                      hintStyle: TextStyle(
                        fontSize: 20,
                      )),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: (() {
                  flutterTts.speak(controller.text);
                }),
                child: const Text('Speak'),
              ),
              ElevatedButton(
                onPressed: (() {
                  flutterTts.stop();
                }),
                child: const Text('Pause'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
