import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

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

  Future<List<int>> _readDocumentData(String name) async {
    final ByteData data = await rootBundle.load('assets/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  @override
  Widget build(BuildContext context) {
    void showResult(String text) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Extracted text'),
              content: Scrollbar(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  child: Text(text),
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: (() => flutterTts.speak(text)),
                      child: const Text('Speak'),
                    ),
                    ElevatedButton(
                      onPressed: (() => Navigator.of(context).setState(() {
                            flutterTts.stop();
                          })),
                      child: const Text('Stop'),
                    ),
                    ElevatedButton(
                      child: const Text('Close'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                )
              ],
            );
          });
    }

    Future<String> generatePDF() async {
      //Load an existing PDF document.
      PdfDocument document = PdfDocument(
          inputBytes:
              await _readDocumentData('Carta de Apresentação Team.It.pdf'));

      //Create a new instance of the PdfTextExtractor.
      PdfTextExtractor extractor = PdfTextExtractor(document);

      //Extract all the text from the document.
      String text = extractor.extractText();

      showResult(text);

      return text;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Text To Speech App'),
        elevation: 0,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: (() async {
            showResult(await generatePDF());
          }),
          child: const Text('Generate PDF'),
        ),
      ),
    );
  }
}
