import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final dt = DateTime.now();
    final date = DateFormat('MMMM dd, yyyy').format(dt).toUpperCase();
    final day = DateFormat('EEEE').format(dt);
    return Scaffold(
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
                  style: GoogleFonts.federo(color: Colors.white, fontSize:25 ),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
      ),
    );
  }
}