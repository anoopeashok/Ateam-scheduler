import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scheduler/service/local_storage.dart';

import '../../models/scheduler.dart';

class HomeViewModel extends ChangeNotifier {
  LocalStorageService _localStorageService = LocalStorage();
  List<Scheduler> schedulerList = [];
  bool isLoading = false;
  String schedulerMessage = 'No schedulers yet';

  HomeViewModel() {
    getAllScheduler();
  }

  getAllScheduler() async {
    isLoading = true;
    notifyListeners();
    try {
      schedulerList = await _localStorageService.getAllScheduler();
      if (schedulerList.isNotEmpty) {
        schedulerMessage = 'Hi jose, you are available on ';
        for (int i = 0; i < schedulerList.length; i++) {
          schedulerMessage = schedulerMessage +
              listToString(schedulerList[i], i == schedulerList.length - 1);
        }
      } else {
        schedulerMessage = '';
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    }
    isLoading = false;
    notifyListeners();
  }

  String listToString(Scheduler scheduler, bool isLast) {
    String string = isLast ? 'and ${scheduler.day} ' : scheduler.day + " ";
    print(scheduler.toJson());
    if (scheduler.isWholeDayAvailable) {
      print(string);
      return string + ' whole day ';
    } else {
      if (scheduler.isMorningAvailable) {
        string += ' Morning,';
      }
      if (scheduler.isAfterNoonAvailable) {
        string += ' Afternoon,';
      }
      if (scheduler.isEveningAvailable) {
        string += ' Evening, ';
      }
      return string;
    }
  }
}
