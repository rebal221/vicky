import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:vicky/theme.dart';
import 'dart:ui' as ui show Gradient;
import 'package:avatar_glow/avatar_glow.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:vicky/widgets/header.dart';
import 'package:vicky/widgets/search.dart';
import 'package:vicky/widgets/speech_result.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(SpeechSampleApp());

class SpeechSampleApp extends StatefulWidget {
  @override
  _SpeechSampleAppState createState() => _SpeechSampleAppState();
}

/// An example that demonstrates the bsudo dnf install java-11-openjdk asic functionality of the
/// SpeechToText plugin for using the speech recognition capability
/// of the underlying platform.
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

  /// This initializes SpeechToText. That only has to be done
  /// once per application, though calling it again is harmless
  /// it also does nothing. The UX of the sample app ensures that
  /// it can only be called once.

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
        // Get the list of languages installed on the supporting platform so they
        // can be displayed in the UI for selection by the user.
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
    // tts.setPitch(0.8);
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
                    //1st Image of Slider
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: BGColor,
                          boxShadow: [
                            BoxShadow(
                              color: ShadowColor,
                              spreadRadius: 5,
                              blurRadius: 18,
                              offset:
                                  Offset(1, 3), // changes position of shadow
                            ),
                          ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 5),
                                SizedBox(height: 2),
                                SpeechResult(lastWords: lastWords),
                                Container(
                                    width: 150,
                                    child: Lottie.asset('asstes/robot.json')),
                                Lottie.asset('asstes/wave.json',
                                    fit: !speech.isListening
                                        ? BoxFit.none
                                        : null),
                                lastWords == 'hi vicky' ||
                                        lastWords == 'hello' &&
                                            !speech.isListening
                                    ? speak(tts, 'hi there')
                                    : Text(''),
                                lastWords == 'tell me about yourself' &&
                                        !speech.isListening
                                    ? speak(tts,
                                        "i'm vicky ,I am your virtual assistant, what can I help you ?")
                                    : Text(''),
                                lastWords == 'open YouTube' &&
                                        !speech.isListening
                                    ? open(tts, lastWords,
                                        'https://www.youtube.com')
                                    : Text('')
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    //2nd Image of Slider
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: BGColor,
                          boxShadow: [
                            BoxShadow(
                              color: ShadowColor,
                              spreadRadius: 5,
                              blurRadius: 18,
                              offset:
                                  Offset(1, 3), // changes position of shadow
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
                            SizedBox(height: 10),
                            SessionOptionsWidget(_currentLocaleId, _switchLang,
                                _localeNames, _logEvents, _switchLogging),
                          ],
                        ),
                      ),
                    ),

                    //3rd Image of Slider
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
                              offset:
                                  Offset(1, 3), // changes position of shadow
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
                                    offset: Offset(
                                        1, 3), // changes position of shadow
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

                  //Slider Container properties
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
          // Container(
          //   child: Column(
          //     children: <Widget>[
          //       InitSpeechWidget(_hasSpeech, initSpeechState),
          //       SpeechControlWidget(_hasSpeech, speech.isListening,
          //           startListening, stopListening, cancelListening),
          //       SessionOptionsWidget(_currentLocaleId, _switchLang,
          //           _localeNames, _logEvents, _switchLogging),
          //     ],
          //   ),
          // ),
          // Container(
          //   child: Column(
          //     children: <Widget>[
          //       InitSpeechWidget(_hasSpeech, initSpeechState),
          //       SpeechControlWidget(_hasSpeech, speech.isListening,
          //           startListening, stopListening, cancelListening),
          //       SessionOptionsWidget(_currentLocaleId, _switchLang,
          //           _localeNames, _logEvents, _switchLogging),
          //     ],
          //   ),
          // ),
          // Expanded(
          //   flex: 1,
          //   child: ErrorWidget(lastError: lastError),
          // ),
          // SpeechStatusWidget(speech: speech),
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
            // Replace this child with your own
            elevation: 100.0,
            shape: CircleBorder(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: CircleAvatar(
                backgroundColor: Colors.grey.shade700,
                child: GestureDetector(
                  onTap: () {
                    !_hasSpeech || speech.isListening ? null : startListening();

                    // !speech.isListening
                    //     ? waveController.record()
                    //     : waveController.pause();
                  },
                  child: Icon(
                    !_hasSpeech || speech.isListening
                        ? Icons.mic_off
                        : Icons.mic,
                    color: Colors.blue,
                  ),
                ), // image
                radius: 40.0,
              ), // circleAvatar
            ), // ClipRRect
          ), // Material
        ),
      ),
    );
  }

  // This is called each time the users wants to start a new speech
  // recognition session
  void startListening() {
    _logEvent('start listening');
    lastWords = '';
    lastError = '';
    // Note that `listenFor` is the maximum, not the minimun, on some
    // recognition will be stopped before this value is reached.
    // Similarly `pauseFor` is a maximum not a minimum and may be ignored
    // on some devices.
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

  void stopListening() {
    _logEvent('stop');
    speech.stop();
    setState(() {
      level = 0.0;
    });
  }

  void cancelListening() {
    _logEvent('cancel');
    speech.cancel();
    setState(() {
      level = 0.0;
    });
  }

  /// This callback is invoked each time new recognition results are
  /// available after `listen` is called.
  void resultListener(SpeechRecognitionResult result) {
    _logEvent(
        'Result listener final: ${result.finalResult}, words: ${result.recognizedWords}');
    setState(() {
      // lastWords = '${result.recognizedWords} - ${result.finalResult}';
      lastWords = '${result.recognizedWords}';
    });
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    // _logEvent('sound level $level: $minSoundLevel - $maxSoundLevel ');
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

/// Display the current error status from the speech
/// recognizer
class ErrorWidget extends StatelessWidget {
  const ErrorWidget({
    Key? key,
    required this.lastError,
  }) : super(key: key);

  final String lastError;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(
          child: Text(
            'Error Status',
            style: TextStyle(fontSize: 22.0),
          ),
        ),
        Center(
          child: Text(lastError),
        ),
      ],
    );
  }
}

class SessionOptionsWidget extends StatelessWidget {
  const SessionOptionsWidget(this.currentLocaleId, this.switchLang,
      this.localeNames, this.logEvents, this.switchLogging,
      {Key? key})
      : super(key: key);

  final String currentLocaleId;
  final void Function(String?) switchLang;
  final void Function(bool?) switchLogging;
  final List<LocaleName> localeNames;
  final bool logEvents;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Language: '),
            DropdownButton<String>(
              onChanged: (selectedVal) => switchLang(selectedVal),
              value: currentLocaleId,
              items: localeNames
                  .map(
                    (localeName) => DropdownMenuItem(
                      value: localeName.localeId,
                      child: Text(
                        localeName.name,
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
        // Row(
        //   children: [
        //     Text('Log events: '),
        //     Checkbox(
        //       value: logEvents,
        //       onChanged: switchLogging,
        //     ),
        //   ],
        // )
      ],
    );
  }
}

/// Display the current status of the listener
class SpeechStatusWidget extends StatelessWidget {
  const SpeechStatusWidget({
    Key? key,
    required this.speech,
  }) : super(key: key);

  final SpeechToText speech;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      color: Theme.of(context).backgroundColor,
      child: Center(
        child: speech.isListening
            ? Text(
                "I'm listening...",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            : Text(
                'Not listening',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}

speak(TextToSpeech ts, String lastWords) {
  ts.speak(lastWords);
  return Text(lastWords, style: GoogleFonts.lato());
}

open(TextToSpeech ts, String lastWords, String url) {
  final Uri _url = Uri.parse(url);
  ts.speak(lastWords);
  launchUrl(_url);
  return Text(lastWords, style: GoogleFonts.lato());
}
