import 'dart:async';
import 'package:flutter/material.dart';
import '/model/restaurant_list_model.dart';
import '/dataAPI/api.dart';



enum ResultState { Loading, NoData, HasData, Error }

class RestListProvider extends ChangeNotifier {
  final ApiRestList apiRestList;

  RestListProvider({required this.apiRestList}) {
    _takeListRestaurant();
  }
  // ResultState <RestaurantListResponse> _state = ResultState(status: Status.loading, message: null, data: null);
  //
  // ResultState<RestaurantListResponse> get state => _state;
  late RestaurantList _restaurantList;
  late ResultState _state;

  String _message = '';
  String get message => _message;
  RestaurantList get result => _restaurantList;
  ResultState get state => _state;

  Future<dynamic> _takeListRestaurant() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final rest = await apiRestList.getRestList();
      if (rest.restaurant.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Your search is not found. Please try again.';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _restaurantList= rest;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message =
      'Error. Please check your internet connection';
    }
  }
}