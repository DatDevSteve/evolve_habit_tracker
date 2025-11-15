import 'package:evolve_fitness_app/screen_manager.dart';
import 'package:evolve_fitness_app/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://hhaqojnliqzluhwszgjc.supabase.co',
    anonKey: 'sb_publishable_kjH445LzWXNmxmFJTdy5uQ_Bs83NeHO',
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;
    final Widget homeScreen = session != null ? MainScreen() : IntroScreen();

    return MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: Color.fromRGBO(120, 225, 128, 1),
        highlightColor: Color.fromRGBO(120, 225, 128, 1),
        textTheme: GoogleFonts.ibmPlexSansTextTheme(
          Theme.of(context).textTheme,
        ),
        tabBarTheme: TabBarThemeData(
          splashBorderRadius: BorderRadius.circular(15),
          indicatorColor: Color.fromRGBO(120, 225, 128, 1),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: homeScreen,
    );
  }
}
