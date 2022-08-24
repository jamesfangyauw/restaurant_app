import 'dart:async';
import 'package:flutter/material.dart';
import '/dataAPI/api.dart';
import '/model/restaurant_detail_model.dart';

enum ResultState { Loading, NoData, HasData, Error }

class RestDetailProvider extends ChangeNotifier {
  final ApiRestDetail apiRestDetail;

  RestDetailProvider({required this.apiRestDetail}) {
    _takeDetailRestaurant();
  }

  late RestaurantDetail _restaurantDetail;
  late ResultState _state;
  String _message = '';

  String get message => _message;
  RestaurantDetail get result => _restaurantDetail;
  ResultState get state => _state;

  Future<dynamic> _takeDetailRestaurant() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final rest = await apiRestDetail.getRestDetail();
      if (rest.restaurant == null) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Your search is not found. Please try again.';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _restaurantDetail = rest;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message =
      'Error. Please check your internet connection';
    }
  }
}