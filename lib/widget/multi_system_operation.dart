import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class MultiSystemOperation extends StatelessWidget { //make a class
  final WidgetBuilder so_Android; //use final type bcs it's value never change
  final WidgetBuilder so_Ios;

  MultiSystemOperation({required this.so_Android, required this.so_Ios});

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) { //property : defaultTargetPlatform
      case TargetPlatform.android:
        return so_Android(context); //if android, so show android view
      case TargetPlatform.iOS:
        return so_Ios(context);// if iod, so show ios layout
      default:
        return so_Android(context);//default is android
    }
  }
}
