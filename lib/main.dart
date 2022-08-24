import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'model/restaurant_list_model.dart';
import 'model/search_model.dart';
import 'ui/home_page.dart';
import 'ui/info_restaurant_detail.dart';
import 'ui/search_detail_feature.dart';
import 'widget/navigation_bar_bottom.dart';
import 'ui/search_feature.dart';
import '/model/favorite_model.dart';
import '/ui/card/card_favorite.dart';
import '/ui/restaurant_detail_fav.dart';
import '/ui/settings_page.dart';
import 'database/background_services.dart';
import 'widget/navigation.dart';
import 'database/notification_helper.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final HelperOfNotif _helperOfNotif = HelperOfNotif();
  final ServiceOfBackground _service = ServiceOfBackground();

  _service.initializeIsolate();
  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }

  await _helperOfNotif.initNotifications(flutterLocalNotificationsPlugin);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Restaurant Apps',
      initialRoute: BottomNavbar.routeName,
      routes: {
        BottomNavbar.routeName: (context) => BottomNavbar(),
        Home.routeName: (context) => Home(),
        RestDetail.routeName: (context) => RestDetail(
          restaurant:
          ModalRoute.of(context)?.settings.arguments as Restaurant,
        ),
        RestSearchFeature.routeName: (context) => RestSearchFeature(
          nameOfRest:
          ModalRoute.of(context)?.settings.arguments as String,
        ),
        RestDetailFromSearching.routeName: (context) => RestDetailFromSearching(
          restaurant: ModalRoute.of(context)?.settings.arguments as RestSearch,
        ),
        RestaurantDetailFav.routeName: (context) => RestaurantDetailFav(
          restOfFavorite:
          ModalRoute.of(context)?.settings.arguments as RestOfFavorite,
        ),
        CardFavorite.routeName: (context) => CardFavorite(),
        FeatureOfSetting.routeName: (context) => FeatureOfSetting(),
      },
    );
  }
}