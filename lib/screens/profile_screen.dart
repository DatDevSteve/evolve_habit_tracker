import 'package:auto_size_text/auto_size_text.dart';
import 'package:evolve_fitness_app/screens/home_screen.dart';
import 'package:evolve_fitness_app/welcome_login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: media.height * 0.1,
        backgroundColor: Color.fromRGBO(22, 25, 15, 1),
        elevation: 15,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        title: AutoSizeText(
          " E V O L V E",
          maxFontSize: 45,
          minFontSize: 30,
          textAlign: TextAlign.center,
          style: GoogleFonts.federo(
            //letterSpacing: 10,
            color: Color.fromRGBO(120, 225, 128, 1),
            fontSize: (media.width < 1000 ? media.width * 0.12 : 100),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
          icon: Icon(
            Icons.keyboard_arrow_left_rounded,
            size: 50,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(child: Card(color: Color.fromRGBO(35, 35, 35, 1))),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: SizedBox(
              width: double.infinity,
              child: Center(
                child: MaterialButton(
                  color: Colors.black,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(15),
                  ),
                  height: 50,
                  minWidth: 390,
                  onPressed: () async {
                    await supabase.auth.signOut();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("You have been logged out!"),
                        duration: Duration(seconds: 5),
                      ),
                    );
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => WelcomePage()),
                    );
                  },
                  child: Text(
                    "Logout",
                    style: GoogleFonts.ibmPlexSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
