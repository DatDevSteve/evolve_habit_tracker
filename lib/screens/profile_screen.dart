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
        toolbarHeight: media.height * 0.45,
        backgroundColor: Color.fromRGBO(22, 25, 15, 1),
        elevation: 15,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                "EVOLVE",
                style: GoogleFonts.federo(
                  letterSpacing: 30,
                  color: Color.fromRGBO(120, 225, 128, 1),
                  fontSize: 40,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Icon(
                Icons.account_circle_sharp,
                color: Colors.white,
                size: 200,
              ),
            ),
            Text(
              supabase.auth.currentUser?.userMetadata?["display_name"] ??
                  "Guest",
              style: GoogleFonts.federo(color: Colors.white, fontSize: 30),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
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
