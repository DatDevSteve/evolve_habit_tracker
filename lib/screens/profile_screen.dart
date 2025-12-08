import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:evolve_fitness_app/screen_manager.dart'; // Import for MainScreen

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "John Doe";
  String joinedDate = "August 25, 2025";
  int habitStreak = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load user data from Supabase
  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      if (user != null) {
        // Get display name from user metadata
        final displayName = user.userMetadata?['display_name'];
        if (displayName != null) {
          setState(() {
            userName = displayName;
          });
        }

        // Get user creation date
        final createdAt = user.createdAt;
        if (createdAt != null) {
          final date = DateTime.parse(createdAt);
          final months = [
            'January', 'February', 'March', 'April', 'May', 'June',
            'July', 'August', 'September', 'October', 'November', 'December'
          ];
          setState(() {
            joinedDate = "${months[date.month - 1]} ${date.day}, ${date.year}";
          });
        }

        // Load habit streak from database
        try {
          final response = await supabase
              .from('user_data')
              .select('streak')
              .eq('uuid', user.id)
              .single();
          setState(() {
            habitStreak = response['streak'] ?? 0;
          });
        } catch (e) {
          print("Error loading streak: $e");
        }
      }
    } catch (e) {
      print("Error loading user data: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Handle logout
  Future<void> _handleLogout() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Log Out"),
        content: Text("Are you sure you want to log out?"),
        actions: [
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: GoogleFonts.ibmPlexSans(
                color: Color.fromRGBO(120, 225, 128, 1),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          MaterialButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await Supabase.instance.client.auth.signOut();
                // Navigate to login screen
                // Navigator.of(context).pushAndRemoveUntil(
                //   MaterialPageRoute(builder: (context) => WelcomePage()),
                //   (route) => false,
                // );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Error logging out: $e"),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text(
              "Log Out",
              style: GoogleFonts.ibmPlexSans(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: Color.fromRGBO(120, 225, 128, 1),
        ),
      )
          : SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header Card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color.fromRGBO(35, 35, 35, 1),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                  child: Column(
                    children: [
                      // EVOLVE Title with Back Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Back Button
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => MainScreen(),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: Color.fromRGBO(120, 225, 128, 1),
                              size: 28,
                            ),
                          ),

                          Spacer(),

                          // EVOLVE Text
                          Text(
                            "EVOLVE",
                            style: GoogleFonts.federo(
                              letterSpacing: 8,
                              color: Color.fromRGBO(120, 225, 128, 1),
                              fontSize: 32,
                              fontWeight: FontWeight.w400,
                            ),
                          ),

                          Spacer(),

                          // Invisible widget for balance
                          SizedBox(width: 44),
                        ],
                      ),
                      SizedBox(height: 30),

                      // Profile Avatar and Info
                      Row(
                        children: [
                          // User Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                AutoSizeText(
                                  userName,
                                  maxLines: 1,
                                  style: GoogleFonts.federo(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: 4),
                                AutoSizeText(
                                  "Joined: $joinedDate",
                                  maxLines: 1,
                                  style: GoogleFonts.ibmPlexSans(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 20),

                          // Profile Picture
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.person,
                              size: 70,
                              color: Color.fromRGBO(35, 35, 35, 1),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Main Content
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  // Habit Streak Card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(254, 94, 41, 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "HABIT STREAK",
                          style: GoogleFonts.ibmPlexSans(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "$habitStreak",
                          style: GoogleFonts.ibmPlexSans(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // Action Buttons
                  _buildActionButton(
                    "Change Account Information",
                        () {
                      // TODO: Navigate to account information screen
                      print("Change Account Information pressed");
                    },
                  ),
                  SizedBox(height: 12),

                  _buildActionButton(
                    "Your Badges",
                        () {
                      // TODO: Navigate to badges screen
                      print("Your Badges pressed");
                    },
                  ),
                  SizedBox(height: 12),

                  _buildActionButton(
                    "Reset Sync Circle",
                        () {
                      // TODO: Show reset sync circle dialog
                      print("Reset Sync Circle pressed");
                    },
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.2),

                  // Log Out Button
                  Container(
                    width: double.infinity,
                    height: 60,
                    child: MaterialButton(
                      onPressed: _handleLogout,
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      child: Text(
                        "Log Out",
                        style: GoogleFonts.ibmPlexSans(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to build action buttons
  Widget _buildActionButton(String text, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      height: 55,
      child: MaterialButton(
        onPressed: onPressed,
        color: Color.fromRGBO(243, 242, 242, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Colors.grey.shade300,
            width: 2,
          ),
        ),
        elevation: 10,
        child: Text(
          text,
          style: GoogleFonts.ibmPlexSans(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
