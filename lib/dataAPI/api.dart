import 'dart:convert';
import 'package:http/http.dart' as http;
import '/model/restaurant_list_model.dart';
import '/model/restaurant_detail_model.dart';
import '/model/search_model.dart';
import '/model/search_detail_model.dart';

class ApiRestList {
  static final String _sourceList = 'https://restaurant-api.dicoding.dev/';

  Future<RestaurantList> getRestList() async {
    final response = await http.get(Uri.parse(_sourceList + 'list'));
    if (response.statusCode == 200) {
      return RestaurantList.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load context, please check your internet connection');
    }
  }
}

class ApiRestDetail {
  static final String _sourceDetail =
      'https://restaurant-api.dicoding.dev/detail/';
  String IDnum_detail;

  ApiRestDetail({required this.IDnum_detail});

  Future<RestaurantDetail> getRestDetail() async {
    final response = await http.get(Uri.parse(_sourceDetail +IDnum_detail));
    if (response.statusCode == 200) {
      return RestaurantDetail.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load context, please check your internet connection');
    }
  }
}

class ApiRestSearch {
  static final String _searchlist =
      'https://restaurant-api.dicoding.dev/search?q=';
  String feature;

  ApiRestSearch({required this.feature});

  Future<RestaurantSearch> getRestSearch() async {
    final response = await http.get(Uri.parse(_searchlist + feature));
    if (response.statusCode == 200) {
      return RestaurantSearch.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load context, please check your internet connection');
    }
  }
}

class ApiRestSearchDetail {
  static final String _searchdetail =
      'https://restaurant-api.dicoding.dev/detail/';
  String IDnum_detail;

  ApiRestSearchDetail({required this.IDnum_detail});

  Future<RestaurantSearchDetail> getRestDetail() async {
    final response = await http.get(Uri.parse(_searchdetail + IDnum_detail));
    if (response.statusCode == 200) {
      return RestaurantSearchDetail.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load context, please check your internet connection');
    }
  }
}