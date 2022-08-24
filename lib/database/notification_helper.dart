import 'dart:convert';
import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '/model/restaurant_list_model.dart';
import 'package:rxdart/rxdart.dart';
import '/widget/navigation.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class HelperOfNotif {
  var rng = new Random();
  var restoItemIndex = 0;
  static HelperOfNotif? _instance;

  HelperOfNotif._internal() {
    _instance = this;
  }

  factory HelperOfNotif() => _instance ?? HelperOfNotif._internal();


  Future<void> initNotifications(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
          if (payload != null) {
            print('notification payload: ' + payload);
          }
          selectNotificationSubject.add(payload ?? 'empty payload');
        });
  }

  Future showNotification(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin, RestaurantList restaurantList) async {
    var _channelId = "1";
    var _channelName = "channel_01";
    var _channelDescription = "dicoding news channel";

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        _channelId, _channelName,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        styleInformation: DefaultStyleInformation(true, true));

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

    restoItemIndex = rng.nextInt(restaurantList.restaurant.length);

    var titleNotification = "<b>Rekomendasi Restoran Untukmu</b>";
    var titleNews = restaurantList.restaurant[restoItemIndex].name;

    await flutterLocalNotificationsPlugin.show(
        0, titleNotification, titleNews, platformChannelSpecifics,
        payload: json.encode(restaurantList.toJson())
    );
  }

  void configureSelectNotificationSubject(String route) {
    selectNotificationSubject.stream.listen((String payload) async {
        var data = RestaurantList.fromJson(json.decode(payload));
        var article = data.restaurant[restoItemIndex];
        Navigation.intentWithData(route, article);
      },
    );
  }
}