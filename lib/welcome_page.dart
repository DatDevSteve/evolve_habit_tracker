import 'package:evolve_fitness_app/welcome_login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromRGBO(35, 35, 35, 1),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: media.height * 0.4),
            Text(
              '"Excellence is not an act, but a habit"',
              textAlign: TextAlign.center,
              style: GoogleFonts.federo(
                color: Color.fromRGBO(120, 225, 128, 1),
                fontSize: 40,
              ),
            ),
            Text(
              '~ Aristotle',
              textAlign: TextAlign.center,
              style: GoogleFonts.federo(
                color: Color.fromRGBO(120, 225, 128, 1),
                fontSize: 20,
              ),
            ),
            SizedBox(height: media.height * 0.29),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MaterialButton(
                  elevation: 5,
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      topRight: Radius.zero,
                      bottomRight: Radius.zero,
                    ),
                  ),
                  height: 90,
                  minWidth: 150,
                  onPressed: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            WelcomePage(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                              const begin = Offset(1.0, 0.0);
                              const end = Offset.zero;
                              const curve = Curves.ease;
                              var tween = Tween(
                                begin: begin,
                                end: end,
                              ).chain(CurveTween(curve: curve));
                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                        transitionDuration: Duration(milliseconds: 500),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.keyboard_arrow_right_outlined,
                    color: Colors.white,
                    size: 65,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
