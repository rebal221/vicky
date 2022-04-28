import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Visual',
          style: GoogleFonts.lato(fontSize: 10),
        ),
        SizedBox(width: 10),
        Container(
          width: 70,
          child: Image.asset('asstes/images/Logo.png'),
        ),
        Text(
          'Assistant',
          style: GoogleFonts.lato(fontSize: 10),
        ),
      ],
    );
  }
}
