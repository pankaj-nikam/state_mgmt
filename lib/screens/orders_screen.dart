import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_mgmt/providers/orders.dart' show Orders;
import 'package:state_mgmt/widgets/order_item.dart';
import 'package:state_mgmt/widgets/side_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/OrdersScreen';
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      drawer: SideDrawer(),
      appBar: AppBar(
        title: Text('Your orders'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return OrderItem(orderData.orders[index]);
        },
        itemCount: orderData.orders.length,
      ),
    );
  }
}
