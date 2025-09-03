import 'package:evolve_fitness_app/screen_manager.dart';
import 'package:evolve_fitness_app/signup.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final emailController = TextEditingController();
  final passwdController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromRGBO(35, 35, 35, 1),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: media.height * 0.2),
            Center(
              child: Text(
                "EVOLVE",
                style: GoogleFonts.federo(
                  letterSpacing: 30,
                  color: Color.fromRGBO(120, 225, 128, 1),
                  fontSize: (media.width < 1000 ? media.width * 0.12 : 100),
                ),
              ),
            ),
            SizedBox(height: media.height * 0.1),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 1, 2, 0),
              child: Card(
                elevation: 20,
                shadowColor: Colors.black,
                color: Color.fromRGBO(225, 225, 225, 1),
                margin: EdgeInsets.all(25),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(35),
                ),
                child: SingleChildScrollView(
                  child: Container(
                    width: (media.width < 1000 && media.height < 690
                        ? media.width * 0.85
                        : 620),
                    height: (media.height < 690 && media.width < 1000
                        ? media.height * 0.55
                        : 350),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: AutoSizeText(
                              "Welcome Back!",
                              maxFontSize: 30,
                              minFontSize: 10,
                              style: GoogleFonts.federo(
                                color: Colors.black,
                                fontSize: 30,
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: AutoSizeText(
                              "Email Address",
                              style: GoogleFonts.ibmPlexSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          //EMAIL ADDRESS TEXTBOX
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Material(
                              elevation: 20,
                              shadowColor: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              child: TextField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  constraints: BoxConstraints(maxHeight: 50),
                                  fillColor: Color.fromRGBO(243, 242, 242, 1),
                                  filled: true,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(120, 225, 128, 1),
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: AutoSizeText(
                              "Password",
                              style: GoogleFonts.ibmPlexSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),

                          /// PASSWORD TEXTBOX:
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Material(
                              elevation: 20,
                              shadowColor: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              child: TextField(
                                controller: passwdController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  constraints: BoxConstraints(maxHeight: 50),
                                  fillColor: Color.fromRGBO(243, 242, 242, 1),
                                  filled: true,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(120, 225, 128, 1),
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          //LOGIN BUTTON:
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: Center(
                                child: MaterialButton(
                                  color: Colors.black,
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadiusGeometry.circular(
                                      15,
                                    ),
                                  ),
                                  height: 50,
                                  minWidth: 390,
                                  onPressed: () async {
                                    final emailID = emailController.text;
                                    final passwd = passwdController.text;

                                    if (emailID.isEmpty || passwd.isEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "All fields are required!",
                                          ),
                                        ),
                                      );
                                      return;
                                    }

                                    try {
                                      final AuthResponse response =
                                          await supabase.auth
                                              .signInWithPassword(
                                                email: emailID,
                                                password: passwd,
                                              );
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(content: Text("Loading"), duration: Duration(seconds: 15),),
                                      );
                                      if (response.session != null) {
                                        final usr = response.user;
                                        print("//INFO | USER LOGGED IN");
                                        ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(content: Text("Welcome back!"), duration: Duration(seconds: 5),),
                                      );
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) => MainScreen(),
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(content: Text("$e")),
                                      );
                                      print("//ERROR | $e ");
                                    }
                                  },
                                  child: Text(
                                    "Login",
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
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: MaterialButton(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusGeometry.circular(
                                    15,
                                  ),
                                ),
                                height: 10,
                                minWidth: 200,
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => SignUpPage(),
                                    ),
                                  );
                                },
                                child: AutoSizeText(
                                  "Sign Up",
                                  style: GoogleFonts.ibmPlexSans(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
