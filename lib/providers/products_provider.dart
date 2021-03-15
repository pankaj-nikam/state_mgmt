import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:state_mgmt/models/http_exception.dart';
import 'product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  final String _token;
  final String _userId;
  Products(this._token, this._userId, this._items);
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
      var response = await http.patch(Uri.parse(url),
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
      final response = await http.post(Uri.parse(url),
          body: jsonEncode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'userId': _userId
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

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    try {
      final filterParams = '&orderBy="userId"&equalTo="$_userId"';
      var url =
          'https://flutter-statemgmt-default-rtdb.firebaseio.com/products.json?auth=$_token';
      if (filterByUser) {
        url += filterParams;
      }
      final response = await http.get(Uri.parse(url));
      final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
      final List<Product> loadedList = [];
      if (extractedData == null) {
        return;
      }
      url =
          'https://flutter-statemgmt-default-rtdb.firebaseio.com/userFavorites/$_userId.json?auth=$_token';
      final favoritesResponse = await http.get(Uri.parse(url));
      final favoriteData = json.decode(favoritesResponse.body);
      extractedData.forEach((productId, productData) {
        loadedList.add(Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            isFavorite:
                favoriteData == null ? false : favoriteData[productId] ?? false,
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
      final result = await http.delete(Uri.parse(url));
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
