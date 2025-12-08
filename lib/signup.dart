import 'package:auto_size_text/auto_size_text.dart';
import 'package:evolve_fitness_app/screen_manager.dart';
import 'package:evolve_fitness_app/welcome_login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwdController = TextEditingController();
  final usrController = TextEditingController();
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
            SizedBox(height: media.height * 0.17),
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
            SizedBox(height: media.height * .16),

            // MAIN CARD WIDGET
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 1, 5, 0),
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
                        ? media.height * 0.7
                        : 450),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Center(
                              child: AutoSizeText(
                                "Create a new account",
                                maxFontSize: 30,
                                minFontSize: 10,
                                style: GoogleFonts.federo(
                                  color: Colors.black,
                                  fontSize: 30,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: AutoSizeText(
                              "Username",
                              style: GoogleFonts.ibmPlexSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),

                          //USERNAME TEXTFIELD
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Material(
                              elevation: 20,
                              shadowColor: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              child: TextField(
                                controller: usrController,
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

                          //SIGN UP BUTTON:
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
                                    final passw = passwdController.text;
                                    final usrName = usrController.text;

                                    if (emailID.isEmpty ||
                                        passw.isEmpty ||
                                        usrName.isEmpty) {
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
                                      final AuthResponse res =
                                      await supabase.auth.signUp(
                                        email: emailID,
                                        password: passw,
                                        data: {
                                          "display_name": usrName,
                                        },
                                      );

                                      if (res.user != null) {
                                        final usr = res.user;
                                        final usrid = usr?.id;
                                        await supabase
                                            .from("user_data")
                                            .insert({
                                          'uuid': usrid,
                                          'user_name': '$usrName',
                                        });
                                        print(
                                          "INFO | USER SIGNED UP $usr",
                                        );
                                        print(
                                          "INFO | ADDED USER TO DATABASE",
                                        );
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Welcome to Evolve, $usrName",
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
                                      print("ERROR | $e");
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    } finally {
                                      setState(() => _isLoading = false);
                                    }
                                  },
                                  child: Text(
                                    "Sign Up",
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
                                onPressed: _isLoading
                                    ? null
                                    : () {
                                  Navigator.of(context).pushReplacement(
                                    PageRouteBuilder(
                                      pageBuilder:
                                          (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                          ) => WelcomePage(),
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
                                  "Login",
                                  minFontSize: 16,
                                  style: GoogleFonts.ibmPlexSans(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
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
            SizedBox(height: 10),
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
