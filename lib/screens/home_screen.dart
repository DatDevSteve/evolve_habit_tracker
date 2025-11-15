import 'package:auto_size_text/auto_size_text.dart';
import 'package:evolve_fitness_app/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evolve_fitness_app/providers/habit_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  List<dynamic> habits = [];
  int streak = 0;
  bool _habitsLoaded = false; // Track if we've already loaded habits
  final supabase = Supabase.instance.client;
  final usrid = Supabase.instance.client.auth.currentUser?.id;
  final habitNameCtrl = TextEditingController();
  final habitDescCtrl = TextEditingController();

  void initState() {
    super.initState();
    // Only load habits once
    if (!_habitsLoaded) {
      fetchHabitsAndStreak();
      _habitsLoaded = true;
    }
  }

  Future<void> fetchHabitsAndStreak() async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Fetch habits
    final response = await supabase
        .from('habit_data')
        .select('habit, habit_desc, last_completed')
        .eq('user_id', usrid as String);

    // Fetch streak
    final userData = await supabase
        .from('user_data')
        .select('streak')
        .eq('uuid', usrid as String)
        .single();

    if (mounted) {
      setState(() {
        habits = response;
        streak = userData['streak'] ?? 0;
      });

      // Sync DB state into the provider, but only if provider is empty
      // Otherwise, trust the persisted local state in SharedPreferences
      final currentProviderState = ref.read(dailyCheckedProvider);
      if (currentProviderState.isEmpty) {
        final checkedFromDb = habits
            .where((h) => (h['last_completed'] ?? '') == today)
            .map<String>((h) => h['habit'].toString());
        // ignore: use_build_context_synchronously
        ref
            .read(dailyCheckedProvider.notifier)
            .setCheckedFromServer(checkedFromDb);
      }
    }
  }

  Future<void> handleCheck(int index, bool? value) async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final habit = habits[index];
    final habitName = habit['habit'].toString();

    final checkedSet = ref.read(dailyCheckedProvider);
    if (checkedSet.contains(habitName)) return; // Already checked today

    // Update provider state immediately so UI reflects the change
    await ref.read(dailyCheckedProvider.notifier).toggle(habitName);

    // Update habit's last_completed in Supabase (in background)
    try {
      await supabase
          .from('habit_data')
          .update({'last_completed': today})
          .eq('user_id', usrid as String)
          .eq('habit', habitName);
      print('Updated last_completed for $habitName to $today');
    } catch (e) {
      print("// ERROR IN UPDATING LAST COMPLETE: $e");
      // Revert the provider state if DB update fails
      await ref.read(dailyCheckedProvider.notifier).toggle(habitName);
      return;
    }

    // Increment streak
    streak += 1;
    try {
      await supabase
          .from('user_data')
          .update({'streak': streak})
          .eq('uuid', usrid as String);
    } catch (e) {
      print("// ERROR IN UPDATING STREAK: $e");
      // Revert the provider state if streak update fails
      await ref.read(dailyCheckedProvider.notifier).toggle(habitName);
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Streak increased!")));
  }

  Future<void> fetchHabits() async {
    final response = await supabase
        .from('habit_data')
        .select('habit, habit_desc')
        .eq('user_id', usrid as Object);
    if (mounted && response.isNotEmpty) {
      setState(() {
        habits = response;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final dt = DateTime.now();
    final date = DateFormat('MMMM dd, yyyy').format(dt).toUpperCase();
    final day = DateFormat('EEEE').format(dt);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Color.fromRGBO(120, 225, 128, 1),
        foregroundColor: Colors.black,
        child: Icon(Icons.add, size: 40),
        onPressed: () {
          showModalBottomSheet(
            backgroundColor: Color.fromRGBO(243, 242, 242, 1),
            context: context,
            builder: (BuildContext context) {
              return Container(
                width: media.width * 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      color: Color.fromRGBO(22, 25, 15, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 15,
                          ),
                          child: Text(
                            "Create a New Habit",
                            style: GoogleFonts.federo(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Color.fromRGBO(120, 225, 128, 1),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 5,
                      ),
                      child: AutoSizeText(
                        "HABIT",
                        style: GoogleFonts.ibmPlexSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    //HABIT NAME TEXTBOX
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Material(
                        elevation: 10,
                        shadowColor: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        child: TextField(
                          controller: habitNameCtrl,
                          decoration: InputDecoration(
                            hintText: "What is the habit?",
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 5,
                      ),
                      child: AutoSizeText(
                        "DESCRIPTION (OPTIONAL)",
                        style: GoogleFonts.ibmPlexSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    //HABIT DESCRIPTION TEXTBOX
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Material(
                        elevation: 10,
                        shadowColor: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        child: TextField(
                          controller: habitDescCtrl,
                          decoration: InputDecoration(
                            hintText:
                                "A breif description or note on this habit",
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
                      padding: const EdgeInsets.fromLTRB(10, 5, 5, 1),
                      child: AutoSizeText(
                        "HABIT FREQUENCY",
                        style: GoogleFonts.ibmPlexSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 0,
                      ),
                      child: AutoSizeText(
                        "How many times you would like to perform this habit in a week?",
                        style: GoogleFonts.ibmPlexSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    //HABIT FREQUENCY
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Material(
                        shadowColor: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        child: TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: "COMING SOON, STAY TUNED :)",
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
                              final hname = habitNameCtrl.text;
                              final hdesc = habitDescCtrl.text;
                              if (hname.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Please mention the habit name!",
                                    ),
                                  ),
                                );
                                return;
                              } else {
                                await supabase.from("habit_data").insert({
                                  'habit': hname,
                                  'habit_desc': hdesc,
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("New habit created!")),
                                );
                                Navigator.pop(context);
                                print(
                                  "INFO// NEW HABIT WAS CREATED AND ADDED IN DATABASE",
                                );
                                fetchHabits();
                              }
                            },
                            child: Text(
                              "Create",
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
            },
          );
        },
      ),
      appBar: AppBar(
        toolbarHeight: 100,
        title: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                child: Text(
                  date,
                  style: GoogleFonts.federo(color: Colors.white, fontSize: 25),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                child: Text(
                  day,
                  style: GoogleFonts.federo(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Color.fromRGBO(22, 25, 15, 1),
        elevation: 15,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            supabase.auth.signOut();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => IntroScreen()),
            );
          },
          icon: Icon(
            Icons.account_circle_rounded,
            size: 50,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: habits.length,
        itemBuilder: (context, index) {
          final habit = habits[index];
          return CheckboxListTile(
            value: ref
                .watch(dailyCheckedProvider)
                .contains(habit['habit'].toString()),
            title: Text(habit['habit']),
            subtitle: Text(habit['habit_desc']),
            onChanged: (bool? value) {
              if (value == true) handleCheck(index, value);
            },
          );
        },
      ),
    );
  }
}
