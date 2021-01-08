import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  void updateProduct(Product product) {
    final indexOfProduct = _items.indexWhere((f) => f.id == product.id);
    if (indexOfProduct >= 0) {
      _items[indexOfProduct] = product;
      notifyListeners();
    }
  }

  Future<void> addProduct(Product product) async {
    const url =
        'https://flutter-statemgmt-default-rtdb.firebaseio.com/products.json';
    try {
      final response = await http.post(url,
          body: jsonEncode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavorite': product.isFavorite,
          }));
      final responseMap = jsonDecode(response.body);
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: responseMap['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> fetchAndSetProducts() async {
    const url =
        'https://flutter-statemgmt-default-rtdb.firebaseio.com/products.json';
    try {
      final response = await http.get(url);
      final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
      final List<Product> loadedList = [];
      extractedData.forEach((productId, productData) {
        loadedList.add(Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            isFavorite: productData['isFavorite'],
            imageUrl: productData['imageUrl']));
      });
      _items = loadedList;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((f) => f.id == id);
    notifyListeners();
  }

  Product getProductById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }
}
