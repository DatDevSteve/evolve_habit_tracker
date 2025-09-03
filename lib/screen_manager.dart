import 'package:evolve_fitness_app/screens/home_screen.dart';
import 'package:evolve_fitness_app/screens/new_habit.dart';
import 'package:evolve_fitness_app/screens/profile_screen.dart';
import 'package:evolve_fitness_app/screens/settings_screen.dart';
import 'package:evolve_fitness_app/screens/stats_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 2,length: 5, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BottomBar(
        barColor: Color.fromRGBO(22, 25, 15, 1),
        body: (context, controller) =>
            TabBarView(controller: tabController, children: [
              ProfileScreen(),
              StatsScreen(),
              HomeScreen(),
              SettingsScreen(),
              NewHabitScreen(),
            ]),
        child: TabBar(
          controller: tabController,
          tabs: [
            Icon(Icons.person),
            Icon(Icons.bar_chart),
            Icon(Icons.data_saver_off_rounded),
            Icon(Icons.settings),
            Icon(
              Icons.add_circle_sharp,
              color: Color.fromRGBO(120, 225, 128, 1),
            ),
          ],
        ),
      ),
    );
  }
}
