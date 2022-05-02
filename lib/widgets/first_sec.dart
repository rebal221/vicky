import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:vicky/theme.dart';
import 'package:vicky/widgets/functions.dart';
import 'package:vicky/widgets/speech_result.dart';

class FirstSection extends StatelessWidget {
  const FirstSection({
    Key? key,
    required this.lastWords,
    required this.speech,
    required this.tts,
  }) : super(key: key);

  final String lastWords;
  final SpeechToText speech;
  final TextToSpeech tts;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: BGColor,
          boxShadow: [
            BoxShadow(
              color: ShadowColor,
              spreadRadius: 5,
              blurRadius: 18,
              offset: Offset(1, 3), // changes position of shadow
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
                Container(width: 150, child: Lottie.asset('asstes/robot.json')),
                Lottie.asset('asstes/wave.json',
                    fit: !speech.isListening ? BoxFit.none : null),
                wordsclassification(lastWords, speech, tts),
                // lastWords == 'hi vicky' ||
                //         lastWords == 'hello' && !speech.isListening
                //     ? speak(tts, 'hi there')
                //     : Text(''),
                // lastWords == 'tell me about yourself' && !speech.isListening
                //     ? speak(tts,
                //         "i'm vicky ,I am your virtual assistant, what can I help you ?")
                //     : Text(''),
                lastWords == 'open YouTube' && !speech.isListening
                    ? open(tts, lastWords, 'https://www.youtube.com')
                    : Text('')
              ],
            ),
          ),
        ],
      ),
    );
  }
}

wordsclassification(String words, SpeechToText speech, TextToSpeech tts) {
  if (words.isNotEmpty && !speech.isListening) {
    speak(tts, words, speech);
  }

  return Text('', style: GoogleFonts.lato());
}
