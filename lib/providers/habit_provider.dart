import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

/// Holds the set of habit identifiers (we use habit name here) that have
/// been checked for the current day. Data is persisted to
/// SharedPreferences under a day-specific key so the state survives navigation
/// and app restarts. The state is automatically cleared when the clock
/// crosses into the next day.
class DailyCheckedNotifier extends StateNotifier<Set<String>> {
  DailyCheckedNotifier() : super(<String>{}) {
    _init();
  }

  Timer? _midnightTimer;

  String _keyForDate(DateTime date) {
    return 'checked_${DateFormat('yyyy-MM-dd').format(date)}';
  }

  Future<void> _init() async {
    await _loadForToday();
    _scheduleMidnightReset();
  }

  Future<void> _loadForToday() async {
    final prefs = await SharedPreferences.getInstance();
    final key = _keyForDate(DateTime.now());
    final items = prefs.getStringList(key) ?? <String>[];
    state = Set<String>.from(items);
    print('DEBUG: Loaded checked items from SharedPreferences: $state');
  }

  Future<void> _saveForToday() async {
    final prefs = await SharedPreferences.getInstance();
    final key = _keyForDate(DateTime.now());
    await prefs.setStringList(key, state.toList());
    print(
      'DEBUG: Saved checked items to SharedPreferences for key $key: $state',
    );
  }

  Future<void> toggle(String habitId) async {
    final newSet = Set<String>.from(state);
    if (newSet.contains(habitId)) {
      newSet.remove(habitId);
    } else {
      newSet.add(habitId);
    }
    state = newSet;
    await _saveForToday();
  }

  Future<void> setCheckedFromServer(Iterable<String> habitIds) async {
    state = Set<String>.from(habitIds);
    await _saveForToday();
  }

  /// Clear today's state (used when day rolls over)
  Future<void> _clearForNewDay() async {
    state = <String>{};
    await _saveForToday();
  }

  void _scheduleMidnightReset() {
    _midnightTimer?.cancel();
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final duration = tomorrow.difference(now);
    _midnightTimer = Timer(duration + const Duration(seconds: 1), () async {
      // At or just after midnight: clear and reschedule
      await _clearForNewDay();
      _scheduleMidnightReset();
    });
  }

  @override
  void dispose() {
    _midnightTimer?.cancel();
    super.dispose();
  }
}

final dailyCheckedProvider =
    StateNotifierProvider<DailyCheckedNotifier, Set<String>>(
      (ref) => DailyCheckedNotifier(),
    );
