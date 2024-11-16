import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Text text(String text, double size, Color color, FontWeight weight) {
  return Text(
    text,
    style: GoogleFonts.prata(color: color, fontSize: size, fontWeight: weight),
  );
}

Text text2(String text, double size, Color color, FontWeight weight) {
  return Text(
    text,
    style:
        GoogleFonts.aBeeZee(color: color, fontSize: size, fontWeight: weight),
  );
}
