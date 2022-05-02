import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

speak(TextToSpeech ts, String lastWords, SpeechToText speech) {
  if (!speech.isListening) sendMessage(lastWords, ts);

  return Text('', style: GoogleFonts.lato());
}

open(TextToSpeech ts, String lastWords, String url) {
  final Uri _url = Uri.parse(url);
  ts.speak(lastWords);
  launchUrl(_url);
  return Text(lastWords, style: GoogleFonts.lato());
}

sendMessage(msg, TextToSpeech ts) {
  WebSocketChannel? channel;
  try {
    channel = WebSocketChannel.connect(Uri.parse('ws://192.168.1.134:3000/'));
  } catch (e) {
    print("Error on connecting to websocket: " + e.toString());
  }
  channel?.sink.add(msg);

  channel?.stream.listen((event) {
    if (event!.isNotEmpty) {
      channel!.sink.close();
      print(event);
      ts.speak(event);
    }
  });
}
