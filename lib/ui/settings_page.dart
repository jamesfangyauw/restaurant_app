import 'dart:io';
import '/provider/scheduling_provider.dart';
import '/widget/custom_dialog.dart';
import '/widget/multi_system_operation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeatureOfSetting extends StatelessWidget {
  static const String settingsTitle = 'Settings';
  static const routeName = '/settings_page';


  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(settingsTitle),
      ),
      body: _buildList(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(settingsTitle),
      ),
      child: _buildList(context),
    );
  }

  Widget _buildList(BuildContext context) {
    return ListView(
      children: [
        Material(
          child: ListTile(
            title: Text('Rekomendasi Reminder'),
            trailing: Consumer<ProviderOfScheduling>(
              builder: (context, scheduled, _) {
                return Switch.adaptive(
                  value: scheduled.isScheduled,
                  onChanged: (value) async {
                    if (Platform.isIOS) {
                      customDialog(context);
                    } else {
                      if(scheduled.isScheduled == false) {
                        scheduled.scheduledNews(true);
                      } else {
                        scheduled.scheduledNews(false);
                      }
                    }
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiSystemOperation(
      so_Android: _buildAndroid,
      so_Ios: _buildIos,
    );
  }
}