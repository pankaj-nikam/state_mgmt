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

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final now = DateTime.now();
    const url =
        'https://flutter-statemgmt-default-rtdb.firebaseio.com/orders.json';
    try {
      final response = await http.post(url,
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
