import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scheduler/service/local_storage.dart';

import '../../models/scheduler.dart';

class SchedulerViewModel extends ChangeNotifier {
  LocalStorageService _localStorageService = LocalStorage();
  bool isLoading = false;
  List<Scheduler> scheduleList = [];

  List schedulerMarker = [
    {'day': 'SUN', 'avalilable': false},
    {'day': 'MON', 'avalilable': false},
    {'day': 'TUE', 'avalilable': false},
    {'day': 'WED', 'avalilable': false},
    {'day': 'THU', 'avalilable': false},
    {'day': 'FRI', 'avalilable': false},
    {'day': 'SAT', 'avalilable': false}
  ];

  SchedulerViewModel() {
    getAllSchedulers();
  }

  getSchedulerByID(id) {
    for (int i = 0; i < scheduleList.length; i++) {
      if (scheduleList[i].id == id) {
        return scheduleList[i];
      }
    }
  }

  setNotAvailable(id) {
    for (int i = 0; i < scheduleList.length; i++) {
      if (scheduleList[i].id == id) {
        scheduleList[i].setNotAvailableToday();
      }
    }
    updateList();
  }

  setAvailable(id) {
      scheduleList.add(Scheduler(
          id: id,
          day: idtoDayMap(id),
          isAfterNoonAvailable: true,
          isMorningAvailable: true,
          isEveningAvailable: true));
    
    for (int i = 0; i < scheduleList.length; i++) {
      if (scheduleList[i].id == id) {
        scheduleList[i].setWholeDayAvailable();
      }
    }
    updateList();
  }

  getAllSchedulers() async {
    isLoading = true;
    notifyListeners();

    try {
      scheduleList = await _localStorageService.getAllScheduler();
      if (scheduleList.isNotEmpty) {
        for (int i = 0; i < schedulerMarker.length; i++) {
          for (int j = 0; j < scheduleList.length; j++) {
            if (schedulerMarker[i]['day'] == scheduleList[j].id) {
              schedulerMarker[i]['avalilable'] = true;
            }
          }
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString(), toastLength: Toast.LENGTH_LONG);
    }

    isLoading = false;
    notifyListeners();
  }

  idtoDayMap(id) {
    switch (id) {
      case 'SUN':
        return 'Sunday';
      case 'MON':
        return 'Monday';
      case 'TUE':
        return 'Tuesday';
      case 'WED':
        return 'Wednesday';
      case 'THU':
        return 'Thursday';
      case 'FRI':
        return 'Friday';
      case 'SAT':
        return 'Saturday';
    }
  }

  updateSchedule(String id, String session, bool isActive) {
    if (scheduleList.isEmpty) {
      scheduleList.add(Scheduler(
          id: id,
          day: idtoDayMap(id),
          isAfterNoonAvailable: session == 'Afternoon' ? isActive : false,
          isMorningAvailable: session == 'Morning' ? isActive : false,
          isEveningAvailable: session == 'Evening' ? isActive : false));
    }
    for (int i = 0; i < scheduleList.length; i++) {
      if (scheduleList[i].id == id) {
        switch (session) {
          case 'Morning':
            scheduleList[i].isMorningAvailable = isActive;
            break;
          case 'Afternoon':
            scheduleList[i].isAfterNoonAvailable = isActive;
            break;
          case 'Evening':
            scheduleList[i].isEveningAvailable = isActive;
        }
        scheduleList[i].setOtherValue();
      }
    }
    updateList();
    notifyListeners();
  }

  updateList() {
    for (int i = 0; i < scheduleList.length; i++) {
      for (int j = 0; j < schedulerMarker.length; j++) {
        if (scheduleList[i].id == schedulerMarker[j]['day']) {
          schedulerMarker[j]['avalilable'] = scheduleList[i].isAvailableToday;
        }
      }
    }
    notifyListeners();
  }

  save(context) async {
    scheduleList.removeWhere((element) => element.isAvailableToday == false);
    await _localStorageService.addNewScheduler(scheduleList);
    Navigator.pop(context, true);
  }
}
