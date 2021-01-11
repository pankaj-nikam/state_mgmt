import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:state_mgmt/models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;
  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavoriteValue(bool value) {
    isFavorite = value;
    notifyListeners();
  }

  Future<void> toggleFavorite() async {
    final oldFavoriteStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        'https://flutter-statemgmt-default-rtdb.firebaseio.com/products/$id.json';
    try {
      var response = await http.patch(url,
          body: jsonEncode({
            'isFavorite': isFavorite,
          }));
      if (response.statusCode != 200) {
        _setFavoriteValue(oldFavoriteStatus);
      }
    } catch (e) {
      _setFavoriteValue(oldFavoriteStatus);
    }
  }
}
