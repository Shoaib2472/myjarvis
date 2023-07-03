import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:myjarvis/feature_box.dart';
import 'package:myjarvis/openai_service.dart';
import 'package:myjarvis/pallete.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  final _speechToText = SpeechToText();
  bool _speechEnabled = false;
  OpenAIService openAIService = OpenAIService();
  final fluttertts = FlutterTts();
  String lastWords = '';
  String? imageContent;
  String? textContent;
  int start = 200;
  int delay = 200;
  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void> initTextToSpeech() async {
    await fluttertts.setSharedInstance(true);
    setState(() {}); //so that it renders
  }

  Future<void> systemSpeak(String content) async {
    await fluttertts.speak(content);
  }

  Future<void> initSpeechToText() async {
    await _speechToText.initialize();
    setState(() {});
  }

  Future<void> _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult); //sending the recognized words

    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method./
  Future<void> _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _speechToText.stop();
    fluttertts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: BounceInDown(child: const Text('Samantha')),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.menu),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Center(
              child: ZoomIn(
                child: Stack(
                  children: [
                    Container(
                      height: 100,
                      width: 110,
                      margin: EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(color: Pallete.assistantCircleColor, shape: BoxShape.circle),
                    ),
                    Container(
                      height: 103,
                      width: 110,
                      decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(image: AssetImage('assets/images/virtualAssistant.png'))),
                    )
                  ],
                ),
              ),
            ),
            FadeInRight(
              child: Visibility(
                visible: imageContent == null,
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    margin: EdgeInsets.symmetric(horizontal: 40).copyWith(top: 20),
                    decoration: BoxDecoration(border: Border.all(color: Pallete.blackColor), borderRadius: BorderRadius.circular(10).copyWith(topLeft: Radius.zero)),
                    child: Text(
                      textContent == null ? 'Good Morning, What task \ncan I do for you?' : textContent!,
                      style: TextStyle(color: Pallete.mainFontColor, fontSize: textContent == null ? 18 : 15, fontFamily: 'ceraPro'),
                    )),
              ),
            ),
            if (imageContent != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.network(imageContent!),
                ),
              ),
            FadeInRight(child: Visibility(visible: textContent == null && imageContent == null, child: Container(alignment: Alignment.centerLeft, padding: EdgeInsets.only(left: 20), margin: EdgeInsets.only(top: 15), child: const Text('Here are Some Few Command', style: TextStyle(color: Pallete.mainFontColor, fontSize: 15, fontFamily: 'ceraPro'))))),
            Visibility(
              visible: textContent == null && imageContent == null,
              child: Column(
                children: [
                  SlideInLeft(
                    duration: Duration(milliseconds: start),
                    child: featureBox(
                      headertext: 'Chat GPT',
                      color: Pallete.firstSuggestionBoxColor,
                      descriptionText: 'A smarter way to stay organized and informed with ChatGPT',
                    ),
                  ),
                  SlideInLeft(
                    duration: Duration(milliseconds: start + delay),
                    child: featureBox(
                      headertext: 'Dall E',
                      color: Pallete.secondSuggestionBoxColor,
                      descriptionText: 'Get inspired and stay creative with your personal assistant powered by Dall-',
                    ),
                  ),
                  SlideInLeft(
                    duration: Duration(milliseconds: start + 2 * delay),
                    child: featureBox(
                      headertext: 'Smart Voice Assistant',
                      color: Pallete.thirdSuggestionBoxColor,
                      descriptionText: 'Get the best of both worlds with a voice assistant powered by Dall-E and ChatGPT',
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: ZoomIn(
        child: FloatingActionButton(
          backgroundColor: Pallete.firstSuggestionBoxColor,
          onPressed: () async {
            if (await _speechToText.hasPermission && _speechToText.isNotListening) {
              await _startListening();
            } else if (_speechToText.isListening) {
              print('words' + lastWords);
              // final res = await openAIService.isArtPromptAPI('What is Programming ?');
              // if (res.contains('http:')) {
              //   imageContent = res;
              //   textContent = null;
              //   setState(() {});
              // } else {
              //   imageContent = null;
              //   textContent = res;
              //   setState(() {});
              //   await systemSpeak(res);
              // }
              await _stopListening();
              //   print('response' + res);
            } else {
              initSpeechToText();
            }
          },
          child: Icon(_speechToText.isListening ? Icons.stop : Icons.mic),
        ),
      ),
    );
  }
}
