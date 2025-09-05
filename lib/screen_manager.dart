import 'package:evolve_fitness_app/screens/home_screen.dart';
import 'package:evolve_fitness_app/screens/new_habit.dart';
import 'package:evolve_fitness_app/screens/profile_screen.dart';
import 'package:evolve_fitness_app/screens/settings_screen.dart';
import 'package:evolve_fitness_app/screens/stats_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';

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
        width: 350,
        borderRadius: BorderRadius.circular(15),
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
          enableFeedback: false,
          indicator: null,
          unselectedLabelColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 0),
          indicatorColor: Colors.transparent,
          //labelPadding: EdgeInsets.all(20),
          labelColor: Color.fromRGBO(120, 225, 128, 1),
          controller: tabController,
          tabs: [
            Icon(Icons.account_circle_rounded,size: 30, applyTextScaling: true,),
            Icon(Icons.bar_chart,size: 30, applyTextScaling: true),
            Icon(Icons.data_saver_off_rounded, size: 30, applyTextScaling: true),
            Icon(Icons.settings, size: 30, applyTextScaling: true),
            Icon(
              Icons.add_circle_sharp,
              size: 35,
              color: Color.fromRGBO(120, 225, 128, 1),
            ),
          ],
        ),
      ),
    );
  }
}
