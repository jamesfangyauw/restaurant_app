import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/dataAPI/api.dart';
import '/provider/restaurant_list_provider.dart';
import '/ui/home_page.dart';
import '/widget/multi_system_operation.dart';
import '/database/notification_helper.dart';
import '/provider/scheduling_provider.dart';
import '/ui/card/card_favorite.dart';
import '/ui/info_restaurant_detail.dart';
import '/ui/settings_page.dart';

class BottomNavbar extends StatefulWidget { //this is for make bar navigation on bottom
  static const routeName = '/home'; //set routeName
  const BottomNavbar({Key? key}) : super(key: key);

  @override
  _BottomNavbarState createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _bottomNavIndex = 0;
  final HelperOfNotif _helperOfNotif = HelperOfNotif();

  @override
  Widget build(BuildContext context) {
    return MultiSystemOperation(
      so_Android: _buildAndroid,
      so_Ios: _buildIos,
    );
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  List<Widget> _listWidget = [
    ChangeNotifierProvider<RestListProvider>(
      create: (_) => RestListProvider(apiRestList: ApiRestList()),
      child: Home(),
    ),
    CardFavorite(),
    ChangeNotifierProvider<ProviderOfScheduling>(
      create: (_) => ProviderOfScheduling(),
      child: FeatureOfSetting(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _helperOfNotif.configureSelectNotificationSubject(RestDetail.routeName);
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      body: _listWidget[_bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        items: _bottomNavBarItems,
        onTap: _onBottomNavTapped,
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(items: _bottomNavBarItems),
      tabBuilder: (context, index) {
        return _listWidget[index];
      },
    );
  }

  List<BottomNavigationBarItem> _bottomNavBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS ? CupertinoIcons.news : Icons.home),
      label: "MY HOME",
    ),
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS ? CupertinoIcons.heart : Icons.favorite),
      label: "MY FAVORITE RESTAURANT ",
    ),
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS ? CupertinoIcons.settings : Icons.settings),
      label: "Settings",
    ),
  ];
}
