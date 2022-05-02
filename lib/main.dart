import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vicky/theme.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:vicky/widgets/first_sec.dart';
import 'package:vicky/widgets/header.dart';
import 'package:vicky/widgets/lan.dart';
import 'package:vicky/widgets/search.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

void main() => runApp(SpeechSampleApp());

class SpeechSampleApp extends StatefulWidget {
  @override
  _SpeechSampleAppState createState() => _SpeechSampleAppState();
}

class _SpeechSampleAppState extends State<SpeechSampleApp>
    with TickerProviderStateMixin {
  bool _hasSpeech = false;
  bool _logEvents = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = '';
  String lastError = '';
  String lastStatus = '';
  String _currentLocaleId = '';
  List<LocaleName> _localeNames = [];
  double _value = 0.5;
  double _value2 = 0.5;
  TextToSpeech tts = TextToSpeech();
  final SpeechToText speech = SpeechToText();
  late final AnimationController _controller;
  late bool _switchValue = false;
  late String shareLinke = 'Https://Vicky/api_key="25236236"/Id=236237';
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: _textController.text));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Copied to clipboard'),
    ));
  }

  Future<void> initSpeechState() async {
    _logEvent('Initialize');
    try {
      var hasSpeech = await speech.initialize(
        onError: errorListener,
        onStatus: statusListener,
        debugLogging: true,
      );
      if (hasSpeech) {
        _localeNames = await speech.locales();
        var systemLocale = await speech.systemLocale();
        _currentLocaleId = systemLocale?.localeId ?? '';
      }
      if (!mounted) return;
      setState(() {
        _hasSpeech = hasSpeech;
      });
    } catch (e) {
      setState(() {
        lastError = 'Speech recognition failed: ${e.toString()}';
        _hasSpeech = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _textController.text = shareLinke;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeDataDark,
      home: Scaffold(
        body: Column(children: [
          SizedBox(height: 50),
          Header(),
          SizedBox(height: 5),
          SearchWidget(),
          Container(
            height: 450,
            child: ListView(
              children: [
                CarouselSlider(
                  items: [
                    FirstSection(
                        lastWords: lastWords, speech: speech, tts: tts),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: BGColor,
                          boxShadow: [
                            BoxShadow(
                              color: ShadowColor,
                              spreadRadius: 5,
                              blurRadius: 18,
                              offset: Offset(1, 3),
                            ),
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20),
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Settings',
                                    style: GoogleFonts.lato(fontSize: 25)),
                                SizedBox(width: 15),
                                Icon(Icons.settings)
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Initialize',
                                    style: GoogleFonts.lato(fontSize: 15)),
                                CupertinoSwitch(
                                  activeColor: Colors.blue,
                                  value: _switchValue,
                                  onChanged: (value) {
                                    setState(() {
                                      _switchValue = true;
                                      value == true ? initSpeechState() : null;
                                      // print(_currentLocaleId.toString());
                                    });
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Rate',
                                    style: GoogleFonts.lato(fontSize: 15)),
                                Container(
                                  child: SfSlider(
                                    min: 0.0,
                                    max: 1.0,
                                    interval: 0.25,
                                    showTicks: true,
                                    activeColor: Colors.lightBlue.shade600,
                                    inactiveColor: Colors.purple,
                                    value: _value,
                                    onChanged: (dynamic newValue) {
                                      setState(() {
                                        _value = newValue;
                                        tts.setRate(newValue);
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Pitch',
                                    style: GoogleFonts.lato(fontSize: 15)),
                                Container(
                                  child: SfSlider(
                                    min: 0.0,
                                    max: 1.0,
                                    interval: 0.25,
                                    showTicks: true,
                                    activeColor: Colors.lightBlue.shade600,
                                    inactiveColor: Colors.purple,
                                    value: _value2,
                                    onChanged: (dynamic newValue) {
                                      setState(() {
                                        _value2 = newValue;
                                        tts.setPitch(newValue);
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 10),
                            SessionOptionsWidget(_currentLocaleId, _switchLang,
                                _localeNames, _logEvents, _switchLogging),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 500,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: BGColor,
                          boxShadow: [
                            BoxShadow(
                              color: ShadowColor,
                              spreadRadius: 5,
                              blurRadius: 18,
                              offset: Offset(1, 3),
                            ),
                          ]),
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Connect Your Devices',
                                  style: GoogleFonts.lato(fontSize: 20)),
                              SizedBox(width: 15),
                              Icon(Icons.devices)
                            ],
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.black, width: 3),
                                boxShadow: [
                                  BoxShadow(
                                    color: ShadowColor,
                                    spreadRadius: 5,
                                    blurRadius: 5,
                                    offset: Offset(1, 3),
                                  ),
                                ]),
                            child: QrImage(
                              data: shareLinke,
                              version: QrVersions.auto,
                              size: 100,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text('Or', style: GoogleFonts.lato(fontSize: 15)),
                          SizedBox(height: 20),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: BGColor, width: 2),
                              ),
                              child: TextField(
                                style: GoogleFonts.lato(fontSize: 15),
                                controller: _textController,
                                decoration: InputDecoration(
                                  icon: IconButton(
                                    icon: const Icon(Icons.copy),
                                    onPressed: _copyToClipboard,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                  options: CarouselOptions(
                    height: 400.0,
                    enlargeCenterPage: true,
                    autoPlay: false,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                  ),
                ),
              ],
            ),
          )
        ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: AvatarGlow(
          glowColor: Color.fromARGB(255, 4, 88, 214),
          endRadius: 60.0,
          duration: Duration(milliseconds: 1000),
          repeat: true,
          showTwoGlows: true,
          repeatPauseDuration: Duration(milliseconds: 1000),
          child: Material(
            elevation: 100.0,
            shape: CircleBorder(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: CircleAvatar(
                backgroundColor: Colors.grey.shade700,
                child: GestureDetector(
                  onTap: () {
                    !_hasSpeech || speech.isListening ? null : startListening();
                  },
                  child: Icon(
                    !_hasSpeech || speech.isListening
                        ? Icons.mic_off
                        : Icons.mic,
                    color: Colors.blue,
                  ),
                ),
                radius: 40.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void startListening() {
    _logEvent('start listening');
    lastWords = '';
    lastError = '';
    speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 30),
        pauseFor: Duration(seconds: 2),
        partialResults: true,
        localeId: _currentLocaleId,
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        listenMode: ListenMode.confirmation);
    setState(() {});
  }

  void resultListener(SpeechRecognitionResult result) {
    _logEvent(
        'Result listener final: ${result.finalResult}, words: ${result.recognizedWords}');
    setState(() {
      lastWords = '${result.recognizedWords}';
    });
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    setState(() {
      this.level = level;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    _logEvent(
        'Received error status: $error, listening: ${speech.isListening}');
    setState(() {
      lastError = '${error.errorMsg} - ${error.permanent}';
    });
  }

  void statusListener(String status) {
    _logEvent(
        'Received listener status: $status, listening: ${speech.isListening}');
    setState(() {
      lastStatus = '$status';
    });
  }

  void _switchLang(selectedVal) {
    setState(() {
      _currentLocaleId = selectedVal;
    });
    print(selectedVal);
  }

  void _logEvent(String eventDescription) {
    if (_logEvents) {
      var eventTime = DateTime.now().toIso8601String();
      print('$eventTime $eventDescription');
    }
  }

  void _switchLogging(bool? val) {
    setState(() {
      _logEvents = val ?? false;
    });
  }
}
