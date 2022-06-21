import 'dart:convert';

import 'package:scheduler/models/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorageService {
  Future<List<Scheduler>> getAllScheduler();
  Future<void> addNewScheduler(List<Scheduler> scheduler);
}

class LocalStorage implements LocalStorageService {
  SharedPreferences? _sharedPreferences;
  final SCHEDULER_KEY = 'get_all_schedulers';

  @override
  Future<List<Scheduler>> getAllScheduler() async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      var schedules = _sharedPreferences!.getStringList(SCHEDULER_KEY);
      return List<Scheduler>.from(
          schedules!.map((e) => Scheduler.fromJson(jsonDecode(e))));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> addNewScheduler(List<Scheduler> schedulers) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      var listofString = schedulers.map((e) => jsonEncode(e.toJson())).toList();
      _sharedPreferences!.setStringList(SCHEDULER_KEY, listofString);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
