import 'package:flutter/material.dart';
import 'package:state_mgmt/models/product.dart';

class ProductItem extends StatelessWidget {
  final Product _product;
  ProductItem(this._product);
  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Image.network(
        _product.imageUrl,
        fit: BoxFit.cover,
      ),
      footer: GridTileBar(
        leading: IconButton(
          icon: Icon(Icons.favorite),
          onPressed: () {},
        ),
        trailing: IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: () {},
        ),
        backgroundColor: Colors.black54,
        title: Text(
          _product.title,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
