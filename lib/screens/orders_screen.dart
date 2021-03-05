import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_mgmt/providers/orders.dart' show Orders;
import 'package:state_mgmt/widgets/order_item.dart';
import 'package:state_mgmt/widgets/side_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/OrdersScreen';
  @override
  Widget build(BuildContext context) {
    print('Rendering orders');
    return Scaffold(
        drawer: SideDrawer(),
        appBar: AppBar(
          title: Text('Your orders'),
        ),
        body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.hasError == false) {
                return Consumer<Orders>(
                  builder: (ctx, orderData, _) {
                    return orderData.orders.length > 0
                        ? ListView.builder(
                            itemBuilder: (context, index) {
                              return OrderItem(orderData.orders[index]);
                            },
                            itemCount: orderData.orders.length,
                          )
                        : Center(
                            child: Text('No orders yet!'),
                          );
                  },
                );
              } else {
                return Center(
                  child: Text('An error occurred.'),
                );
              }
            }
          },
        ));
  }
}
