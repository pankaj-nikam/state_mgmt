import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:state_mgmt/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String _userId;

  List<OrderItem> get orders {
    return [..._orders];
  }

  Orders(this.authToken, this._userId, this._orders);

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://flutter-statemgmt-default-rtdb.firebaseio.com/orders/$_userId.json?auth=$authToken';
    final response = await http.get(Uri.parse(url));
    final List<OrderItem> loadedOrders = [];
    final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
    if (extractedData == null) return;
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id'],
                  price: item['price'],
                  quantity: item['quantity'],
                  title: item['title'],
                ),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final now = DateTime.now();
    final url =
        'https://flutter-statemgmt-default-rtdb.firebaseio.com/orders/$_userId.json?auth=$authToken';
    try {
      final response = await http.post(Uri.parse(url),
          body: jsonEncode({
            'amount': total,
            'dateTime': now.toIso8601String(),
            'products': cartProducts
                .map((cartProduct) => {
                      'id': cartProduct.id,
                      'title': cartProduct.title,
                      'quantity': cartProduct.quantity,
                      'price': cartProduct.price
                    })
                .toList()
          }));
      final responseMap = jsonDecode(response.body);
      _orders.insert(
        0,
        new OrderItem(
          id: responseMap['name'],
          amount: total,
          products: cartProducts,
          dateTime: now,
        ),
      );
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
