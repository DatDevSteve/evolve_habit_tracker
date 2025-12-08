import 'package:evolve_fitness_app/screen_manager.dart';
import 'package:evolve_fitness_app/signup.dart';
import 'package:flutter/material.dart';
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
  bool _isLoading = false;

  // Helper method to extract user-friendly error message
  String _getErrorMessage(dynamic error) {
    if (error is AuthException) {
      return error.message;
    } else if (error is PostgrestException) {
      return error.message;
    } else {
      return error.toString().replaceAll('Exception: ', '').replaceAll('Error: ', '');
    }
  }

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
            SizedBox(height: media.height * 0.12),
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
            SizedBox(height: media.height * 0.28),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                    width: (media.width < 393 && media.height < 852
                        ? media.width * 0.85
                        : 620),
                    height: (media.height < 450 && media.width < 950
                        ? media.height * 0.5
                        : 390),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
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
                            padding: const EdgeInsets.fromLTRB(2, 5, 2, 5),
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
                          Row(
                            children: [
                              AutoSizeText(
                                "Password",
                                style: GoogleFonts.ibmPlexSans(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (emailController.text.isEmpty == false) {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) => AlertDialog(
                                        title: Text("Forgot Password"),
                                        content: Text(
                                          "Do you want send a password reset link on your entered email address?",
                                          softWrap: true,
                                        ),
                                        actions: [
                                          MaterialButton(
                                            onPressed: () async {
                                              Navigator.pop(context, 'YES');
                                              try {
                                                await supabase.auth
                                                    .resetPasswordForEmail(
                                                  emailController.text,
                                                );
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      "A password reset link has been sent over your email!",
                                                    ),
                                                  ),
                                                );
                                              } catch (e) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(_getErrorMessage(e)),
                                                  ),
                                                );
                                              }
                                            },
                                            child: Text(
                                              "Yes",
                                              style: GoogleFonts.ibmPlexSans(
                                                color: Color.fromRGBO(
                                                  120,
                                                  225,
                                                  128,
                                                  1,
                                                ),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          MaterialButton(
                                            onPressed: () {
                                              Navigator.pop(context, 'NO');
                                            },
                                            child: Text(
                                              "No",
                                              style: GoogleFonts.ibmPlexSans(
                                                color: Color.fromRGBO(
                                                  120,
                                                  225,
                                                  128,
                                                  1,
                                                ),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                            title: Text("Forgot Password"),
                                            content: Text(
                                              "Please enter an email address in the email field and try again",
                                              softWrap: true,
                                            ),
                                            actions: [
                                              MaterialButton(
                                                onPressed: () => Navigator.pop(
                                                  context,
                                                  'Okay',
                                                ),
                                                child: Text(
                                                  "Okay",
                                                  style:
                                                  GoogleFonts.ibmPlexSans(
                                                    color: Color.fromRGBO(
                                                      120,
                                                      225,
                                                      128,
                                                      1,
                                                    ),
                                                    fontWeight:
                                                    FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                    );
                                  }
                                },
                                child: AutoSizeText(
                                  "Forgot Password?",
                                  style: GoogleFonts.ibmPlexSans(
                                    color: Color.fromRGBO(89, 168, 96, 1),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          /// PASSWORD TEXTBOX:
                          Material(
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
                                  onPressed: _isLoading
                                      ? () {
                                    print("// AVOIDING REDUNDANCY");
                                  }
                                      : () async {
                                    setState(() => _isLoading = true);
                                    final emailID = emailController.text;
                                    final passwd = passwdController.text;

                                    if (emailID.isEmpty ||
                                        passwd.isEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "All fields are required!",
                                          ),
                                        ),
                                      );
                                      setState(() => _isLoading = false);
                                      return;
                                    }

                                    try {
                                      final AuthResponse response =
                                      await supabase.auth
                                          .signInWithPassword(
                                        email: emailID,
                                        password: passwd,
                                      );

                                      if (response.session != null) {
                                        final usr = response
                                            .user
                                            ?.userMetadata?['display_name'];
                                        print("//INFO | USER LOGGED IN");
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Welcome back! $usr",
                                            ),
                                            duration: Duration(
                                              seconds: 5,
                                            ),
                                          ),
                                        );
                                        Navigator.of(
                                          context,
                                        ).pushReplacement(
                                          PageRouteBuilder(
                                            pageBuilder:
                                                (
                                                context,
                                                animation,
                                                secondaryAnimation,
                                                ) => MainScreen(),
                                            transitionsBuilder:
                                                (
                                                context,
                                                animation,
                                                secondaryAnimation,
                                                child,
                                                ) {
                                              const begin = Offset(
                                                0.0,
                                                1.0,
                                              );
                                              const end = Offset.zero;
                                              const curve =
                                                  Curves.ease;
                                              var tween =
                                              Tween(
                                                begin: begin,
                                                end: end,
                                              ).chain(
                                                CurveTween(
                                                  curve: curve,
                                                ),
                                              );
                                              return SlideTransition(
                                                position: animation
                                                    .drive(tween),
                                                child: child,
                                              );
                                            },
                                            transitionDuration: Duration(
                                              milliseconds: 500,
                                            ),
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(_getErrorMessage(e)),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      print("//ERROR | $e ");
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    } finally {
                                      setState(() => _isLoading = false);
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

                          // Login with Google
                          MaterialButton(
                            padding: EdgeInsets.fromLTRB(50, 1, 50, 1),
                            color: Colors.transparent,
                            hoverColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            elevation: 0,
                            focusElevation: 0,
                            disabledElevation: 0,
                            highlightElevation: 0,
                            onPressed: () async {
                              try {
                                final AuthResponse response =
                                (await supabase.auth.signInWithOAuth(
                                    OAuthProvider.google,
                                    redirectTo: "https://evolve-habit-tracker-b38hoe4k3-datdevsteves-projects.vercel.app/"
                                ))
                                as AuthResponse;
                                supabase.auth
                                    .onAuthStateChange.listen((data){
                                  final usr = response
                                      .user
                                      ?.userMetadata?['name'];
                                  print("//INFO | USER LOGGED IN");
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Welcome back! $usr"),
                                      duration: Duration(seconds: 5),
                                    ),
                                  );
                                  Navigator.of(context).pushReplacement(
                                    PageRouteBuilder(
                                      pageBuilder:
                                          (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                          ) => MainScreen(),
                                      transitionsBuilder:
                                          (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                          child,
                                          ) {
                                        const begin = Offset(0.0, 1.0);
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
                                      transitionDuration: Duration(
                                        milliseconds: 500,
                                      ),
                                    ),
                                  );
                                });
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(_getErrorMessage(e)),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            child: Center(
                              child: Image.asset(
                                'assets/continueBtn.png',
                                scale: 0.5,
                                height: 40,
                                width: 200,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),

                          // Sign Up Button
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
                                onPressed: _isLoading
                                    ? () {
                                  print("// AVOIDING REDUNDANCY");
                                }
                                    : () {
                                  Navigator.of(context).pushReplacement(
                                    PageRouteBuilder(
                                      pageBuilder:
                                          (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                          ) => SignUpPage(),
                                      transitionsBuilder:
                                          (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                          child,
                                          ) {
                                        const begin = Offset(
                                          0.0,
                                          1.0,
                                        );
                                        const end = Offset.zero;
                                        const curve = Curves.ease;
                                        var tween =
                                        Tween(
                                          begin: begin,
                                          end: end,
                                        ).chain(
                                          CurveTween(
                                            curve: curve,
                                          ),
                                        );
                                        return SlideTransition(
                                          position: animation.drive(
                                            tween,
                                          ),
                                          child: child,
                                        );
                                      },
                                      transitionDuration: Duration(
                                        milliseconds: 500,
                                      ),
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
                          //SizedBox(height: 01),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (_isLoading)
              LinearProgressIndicator(
                backgroundColor: Color.fromRGBO(35, 35, 35, 1),
                color: Color.fromRGBO(120, 225, 128, 1),
              ),
          ],
        ),
      ),
    );
  }
}
