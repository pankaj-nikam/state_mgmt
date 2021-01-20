import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_mgmt/providers/orders.dart' show Orders;
import 'package:state_mgmt/widgets/order_item.dart';
import 'package:state_mgmt/widgets/side_drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/OrdersScreen';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;
  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<Orders>(context, listen: false).fetchAndSetOrders().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      drawer: SideDrawer(),
      appBar: AppBar(
        title: Text('Your orders'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemBuilder: (context, index) {
                return OrderItem(orderData.orders[index]);
              },
              itemCount: orderData.orders.length,
            ),
    );
  }
}
