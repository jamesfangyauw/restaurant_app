import 'dart:ui';
import 'dart:isolate';
import '/main.dart';
import '/dataAPI/api.dart';
import '/database/notification_helper.dart';

final ReceivePort port = ReceivePort();

class ServiceOfBackground {
  static ServiceOfBackground? _instance;
  static String _isolateName = 'isolate';
  static SendPort? _uiSendPort;

  ServiceOfBackground._internal() {
    _instance = this;
  }

  factory ServiceOfBackground() => _instance ?? ServiceOfBackground._internal();

  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      _isolateName,
    );
  }

  static Future<void> callback() async {
    print('Hello World, Alarm Active!');
    final HelperOfNotif _helperOfNotif = HelperOfNotif();
    var result = await ApiRestList().getRestList();
    await _helperOfNotif.showNotification(flutterLocalNotificationsPlugin, result);

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }
}