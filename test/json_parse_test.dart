// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import '../lib/model/restaurant_list_model.dart';

var testRestaurant = {
  "id": "s1knt6za9kkfw1e867",
  "name": "Kafe Kita",
  "description":
  "Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. ...",
  "pictureId": "25",
  "city": "Gorontalo",
  "rating": 4
};

void main() {
  test("Test Parsing", () async {
    var result = Restaurant.fromJson(testRestaurant).id;
    expect(result, "s1knt6za9kkfw1e867");
  });
}