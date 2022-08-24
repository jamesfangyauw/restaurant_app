import 'dart:async';
import 'package:flutter/material.dart';
import '/dataAPI/api.dart';
import '/model/search_detail_model.dart';

enum ResultState { Loading, NoData, HasData, Error }

class RestSearchDetailProv extends ChangeNotifier {
  final ApiRestSearchDetail apiRestSearchDetail;

  RestSearchDetailProv({required this.apiRestSearchDetail}) {
    _takeDetailRestaurant();
  }

  late RestaurantSearchDetail _restaurantSearchDetail;
  late ResultState _state;
  String _message = '';

  String get message => _message;

  RestaurantSearchDetail get result => _restaurantSearchDetail;

  ResultState get state => _state;

  Future<dynamic> _takeDetailRestaurant() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final rest = await apiRestSearchDetail.getRestDetail();
      if (rest.restaurant == null) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Your search is not found. Please try again.';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _restaurantSearchDetail = rest;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message =
      'Error. Please check your internet connection';
    }
  }
}