import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SpeechResult extends StatelessWidget {
  const SpeechResult({
    Key? key,
    required this.lastWords,
  }) : super(key: key);

  final String lastWords;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            lastWords,
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
