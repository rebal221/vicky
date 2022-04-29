import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:url_launcher/url_launcher.dart';

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
