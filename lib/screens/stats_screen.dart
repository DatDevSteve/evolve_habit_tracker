import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evolve_fitness_app/providers/habit_provider.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  final supabase = Supabase.instance.client;
  final usrid = Supabase.instance.client.auth.currentUser?.id;

  int totalHabits = 0;
  int checkedHabits = 0;
  double completionPercentage = 0.0;
  Map<String, bool> monthlyActivity = {}; // date -> completed all habits
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStatsData();
  }

  Future<void> _loadStatsData() async {
    setState(() => _isLoading = true);

    try {
      // Fetch total habits count
      final habitsResponse = await supabase
          .from('habit_data')
          .select('habit, last_completed')
          .eq('user_id', usrid as String);

      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final checkedToday = habitsResponse
          .where((h) => (h['last_completed'] ?? '') == today)
          .length;

      setState(() {
        totalHabits = habitsResponse.length;
        checkedHabits = checkedToday;
        completionPercentage = totalHabits > 0
            ? (checkedHabits / totalHabits) * 100
            : 0.0;
      });

      // Fetch monthly activity data (last 35 days for better heatmap display)
      await _loadMonthlyActivity();

    } catch (e) {
      print("Error loading stats data: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadMonthlyActivity() async {
    try {
      final now = DateTime.now();
      final startDate = DateTime(now.year, now.month, 1);
      final endDate = DateTime(now.year, now.month + 1, 0); // Last day of month

      // Get all habits
      final habitsResponse = await supabase
          .from('habit_data')
          .select('habit, last_completed')
          .eq('user_id', usrid as String);

      final totalHabitsCount = habitsResponse.length;

      // Initialize all days in current month as false
      Map<String, bool> activity = {};
      for (int day = 1; day <= endDate.day; day++) {
        final date = DateTime(now.year, now.month, day);
        final dateStr = DateFormat('yyyy-MM-dd').format(date);
        activity[dateStr] = false;
      }

      // Count completions per day
      Map<String, int> dailyCompletions = {};
      for (var habit in habitsResponse) {
        final lastCompleted = habit['last_completed'];
        if (lastCompleted != null && lastCompleted.toString().isNotEmpty) {
          final completedDate = lastCompleted.toString();
          dailyCompletions[completedDate] = (dailyCompletions[completedDate] ?? 0) + 1;
        }
      }

      // Mark days where all habits were completed
      dailyCompletions.forEach((date, count) {
        if (activity.containsKey(date) && count == totalHabitsCount) {
          activity[date] = true;
        }
      });

      setState(() {
        monthlyActivity = activity;
      });
    } catch (e) {
      print("Error loading monthly activity: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        title: Text(
          "Statistics",
          style: GoogleFonts.federo(
            color: Colors.white,
            fontSize: 28,
          ),
        ),
        backgroundColor: Color.fromRGBO(22, 25, 15, 1),
        elevation: 15,
        shadowColor: Colors.black,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: Color.fromRGBO(120, 225, 128, 1),
        ),
      )
          : RefreshIndicator(
        color: Color.fromRGBO(120, 225, 128, 1),
        onRefresh: _loadStatsData,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Today's Progress Section
                Text(
                  "Today's Progress",
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 20),

                // Circular Progress Ring
                _buildCircularProgress(),

                SizedBox(height: 30),

                // View Your Circle Card
                _buildViewCircleCard(),

                SizedBox(height: 30),

                // Monthly Activity Heatmap
                Text(
                  "Monthly Activity",
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 15),
                _buildMonthlyHeatmap(),

                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Circular Progress Ring Widget
  Widget _buildCircularProgress() {
    String statusText = "Getting Started";
    Color statusColor = Colors.orange;

    if (completionPercentage == 0) {
      statusText = "Not Started";
      statusColor = Colors.red.shade400;
    } else if (completionPercentage < 50) {
      statusText = "Keep Going!";
      statusColor = Colors.orange;
    } else if (completionPercentage < 100) {
      statusText = "Almost There!";
      statusColor = Color.fromRGBO(254, 94, 41, 1);
    } else {
      statusText = "All Done! 🎉";
      statusColor = Color.fromRGBO(120, 225, 128, 1);
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Circular Progress Indicator
          SizedBox(
            width: 200,
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background circle
                CustomPaint(
                  size: Size(200, 200),
                  painter: CircularProgressPainter(
                    progress: completionPercentage / 100,
                    backgroundColor: Colors.grey.shade200,
                    progressColor: statusColor,
                    strokeWidth: 20,
                  ),
                ),
                // Center text
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${completionPercentage.toInt()}%",
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "$checkedHabits / $totalHabits",
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      "habits",
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          // Status Text
          Text(
            statusText,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  // View Your Circle Card Widget
  Widget _buildViewCircleCard() {
    return InkWell(
      onTap: () {
        // TODO: Navigate to Circle Screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Circle feature coming soon!"),
            backgroundColor: Color.fromRGBO(120, 225, 128, 1),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(25),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(254, 94, 41, 1.0),
              Color.fromRGBO(254, 94, 41, 0.7333333333333333),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(120, 225, 128, 0.4),
              blurRadius: 15,
              spreadRadius: 2,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "View Your Circle",
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Track progress with friends",
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.group,
                size: 40,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Monthly Activity Heatmap Widget
  Widget _buildMonthlyHeatmap() {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final startingWeekday = firstDayOfMonth.weekday % 7; // 0 = Sunday

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('MMMM yyyy').format(now),
            style: GoogleFonts.ibmPlexSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 15),

          // Weekday labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 10),

          // Calendar grid
          _buildCalendarGrid(daysInMonth, startingWeekday, now),

          SizedBox(height: 15),

          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(Colors.grey.shade200, "No data"),
              SizedBox(width: 15),
              _buildLegendItem(Color.fromRGBO(120, 225, 128, 0.3), "Incomplete"),
              SizedBox(width: 15),
              _buildLegendItem(Color.fromRGBO(120, 225, 128, 1), "Complete"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(int daysInMonth, int startingWeekday, DateTime now) {
    List<Widget> weeks = [];
    List<Widget> currentWeek = [];

    // Add empty cells for days before the month starts
    for (int i = 0; i < startingWeekday; i++) {
      currentWeek.add(Expanded(child: SizedBox()));
    }

    // Add day cells
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(now.year, now.month, day);
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      final isToday = date.day == now.day &&
          date.month == now.month &&
          date.year == now.year;
      final isFuture = date.isAfter(now);
      final isCompleted = monthlyActivity[dateStr] ?? false;

      Color cellColor;
      if (isFuture) {
        cellColor = Colors.grey.shade200;
      } else if (isCompleted) {
        cellColor = Color.fromRGBO(120, 225, 128, 1);
      } else {
        cellColor = Color.fromRGBO(120, 225, 128, 0.3);
      }

      currentWeek.add(
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: cellColor,
                  borderRadius: BorderRadius.circular(8),
                  border: isToday
                      ? Border.all(
                    color: Color.fromRGBO(254, 94, 41, 1),
                    width: 2,
                  )
                      : null,
                ),
                child: Center(
                  child: Text(
                    '$day',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 12,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                      color: isFuture
                          ? Colors.grey.shade400
                          : (isCompleted || !isFuture)
                          ? Colors.white
                          : Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // If week is complete (7 days) or it's the last day
      if (currentWeek.length == 7) {
        weeks.add(Row(children: List.from(currentWeek)));
        currentWeek.clear();
      }
    }

    // Add remaining empty cells to complete the last week
    while (currentWeek.isNotEmpty && currentWeek.length < 7) {
      currentWeek.add(Expanded(child: SizedBox()));
    }
    if (currentWeek.isNotEmpty) {
      weeks.add(Row(children: currentWeek));
    }

    return Column(children: weeks);
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: 5),
        Text(
          label,
          style: GoogleFonts.ibmPlexSans(
            fontSize: 11,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

// Custom Painter for Circular Progress Ring
class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;
  final double strokeWidth;

  CircularProgressPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from top
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
