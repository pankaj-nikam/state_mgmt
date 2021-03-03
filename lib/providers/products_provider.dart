import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:state_mgmt/models/http_exception.dart';
import 'product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  final _token;
  Products(this._token, this._items);
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Future<void> updateProduct(Product product) async {
    final indexOfProduct = _items.indexWhere((f) => f.id == product.id);
    if (indexOfProduct >= 0) {
      final url =
          'https://flutter-statemgmt-default-rtdb.firebaseio.com/products/${product.id}.json?auth=$_token';
      var response = await http.patch(url,
          body: jsonEncode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
          }));
      if (response.statusCode == 200) {
        _items[indexOfProduct] = product;
        notifyListeners();
      } else {
        throw HttpException("Unable to update product");
      }
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://flutter-statemgmt-default-rtdb.firebaseio.com/products.json?auth=$_token';
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
    final url =
        'https://flutter-statemgmt-default-rtdb.firebaseio.com/products.json?auth=$_token';
    try {
      final response = await http.get(url);
      final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
      final List<Product> loadedList = [];
      if (extractedData == null) {
        return;
      }
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

  Future<void> deleteProduct(String id) async {
    final url =
        'https://flutter-statemgmt-default-rtdb.firebaseio.com/products/$id.json?auth=$_token';
    final existingProductIndex = _items.indexWhere((f) => f.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    try {
      final result = await http.delete(url);
      if (result.statusCode == 200) {
        existingProduct = null;
      } else {
        throw HttpException("Not able to delete the product.");
      }
    } catch (e) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw e;
    }
  }

  Product getProductById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }
}
