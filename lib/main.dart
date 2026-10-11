import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:controle_lotacao/pages/home_page.dart';

void main() {
  GoogleFonts.config.allowRuntimeFetching = false;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Controle do laboratório',
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffed145b)),
      ),
      home: const HomePage(),
    );
  }
}
