import 'package:flutter/material.dart';
import 'package:state_mgmt/widgets/products_grid.dart';
import '../providers/product.dart';

class ProductsOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
      ),
      body: ProductsGrid(),
    );
  }
}
