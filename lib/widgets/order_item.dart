import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/orders.dart' as oi;

class OrderItem extends StatelessWidget {
  final oi.OrderItem _orderItem;

  const OrderItem(this._orderItem);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text(
                NumberFormat.compactSimpleCurrency().format(_orderItem.amount)),
            subtitle: Text(
              DateFormat('dd-MM-yyyy HH:mm').format(_orderItem.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(Icons.expand_more),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
