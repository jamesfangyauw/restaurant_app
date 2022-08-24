import 'dart:async';
import 'package:flutter/material.dart';
import '/dataAPI/api.dart';
import '/model/search_model.dart';

enum ResultState { Loading, NoData, HasData, Error }

class RestSearchProv extends ChangeNotifier {
  final ApiRestSearch apiRestSearch;

  RestSearchProv({required this.apiRestSearch}) {
    _takeRestSearch();
  }

  late RestaurantSearch _restaurantSearch;
  late ResultState _state;

  String _message = '';
  String get message => _message;
  RestaurantSearch get result => _restaurantSearch;
  ResultState get state => _state;

  Future<dynamic> _takeRestSearch() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final rest = await apiRestSearch.getRestSearch();
      if (rest.restaurants.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Your search is not found. Please try again.';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _restaurantSearch = rest;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message =
      'Error. Please check your internet connection';
    }
  }
}