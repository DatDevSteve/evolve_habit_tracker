import 'package:evolve_fitness_app/screens/home_screen.dart';
import 'package:evolve_fitness_app/screens/stats_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1;
  // Use builders so the screens are instantiated at build time (after
  // Flutter bindings are initialized) rather than at import time. This
  // avoids plugins or platform APIs being invoked before
  // WidgetsFlutterBinding.ensureInitialized().
  static final List<Widget Function()> _widgetOptions = <Widget Function()>[
    () => StatsScreen(),
    () => HomeScreen(),
  ];
  final habitNameCtrl = TextEditingController();
  final habitDescCtrl = TextEditingController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_selectedIndex](),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        elevation: 20,
        shadowColor: Colors.black,
        padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
        shape: CircularNotchedRectangle(),
        color: Color.fromRGBO(22, 25, 15, 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(15),
              ),
              splashColor: null,
              onTap: () => _onItemTapped(0),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Icon(
                  Icons.bar_chart_rounded,
                  color: _selectedIndex == 0
                      ? Color.fromRGBO(120, 225, 128, 1)
                      : Colors.white,
                  size: 40,
                ),
              ),
            ),
            SizedBox(width: 50),
            InkWell(
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(15),
              ),
              splashColor: null,
              onTap: () => _onItemTapped(1),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Icon(
                  Icons.checklist,
                  color: _selectedIndex == 1
                      ? Color.fromRGBO(120, 225, 128, 1)
                      : Colors.white,
                  size: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
