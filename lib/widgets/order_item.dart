import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/orders.dart' as oi;
import 'dart:math';

class OrderItem extends StatefulWidget {
  final oi.OrderItem _orderItem;

  const OrderItem(this._orderItem);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool isExpandClicked = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text(NumberFormat.compactSimpleCurrency()
                .format(widget._orderItem.amount)),
            subtitle: Text(
              DateFormat('dd-MM-yyyy HH:mm').format(widget._orderItem.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(isExpandClicked != true
                  ? Icons.expand_more
                  : Icons.expand_less),
              onPressed: () {
                setState(() {
                  isExpandClicked = !isExpandClicked;
                });
              },
            ),
          ),
          if (isExpandClicked)
            Container(
              height: min(widget._orderItem.products.length * 20.0 + 50.0, 100),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: ListView.builder(
                itemCount: widget._orderItem.products.length,
                itemBuilder: (context, index) {
                  final currentProduct = widget._orderItem.products[index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        currentProduct.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${currentProduct.quantity} x ${NumberFormat.compactSimpleCurrency().format(currentProduct.price)}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  );
                },
              ),
            )
        ],
      ),
    );
  }
}
