import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/cupertino.dart';
import '/database/date_time_helper.dart';
import '/database/background_services.dart';

class ProviderOfScheduling extends ChangeNotifier {
  bool _isScheduled = false;
  bool get isScheduled => _isScheduled;

  Future<bool> scheduledNews(bool value) async {
    _isScheduled = value;

    if (_isScheduled == true) { //if value var is tru
      print('Scheduling Resturant Reminder Activated');
      print(_isScheduled);
      notifyListeners();
      return await AndroidAlarmManager.periodic(
        Duration(hours: 24), 1,
        ServiceOfBackground.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else { //if value var is false
      print('Scheduling Restaurant Reminder Canceled');
      print(_isScheduled);
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}