import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

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

  Future<void> toggleFavorite(String token, String userId) async {
    final oldFavoriteStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        'https://flutter-statemgmt-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    try {
      var response = await http.put(url, body: jsonEncode(isFavorite));
      if (response.statusCode != 200) {
        _setFavoriteValue(oldFavoriteStatus);
      }
    } catch (e) {
      _setFavoriteValue(oldFavoriteStatus);
    }
  }
}
