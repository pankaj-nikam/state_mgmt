import 'package:flutter/material.dart';
import 'package:state_mgmt/models/product.dart';
import 'package:state_mgmt/screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  final Product _product;
  ProductItem(this._product);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            ProductDetailsScreen.routeName,
            arguments: _product.id,
          );
        },
        child: GridTile(
          child: Image.network(
            _product.imageUrl,
            fit: BoxFit.cover,
          ),
          footer: GridTileBar(
            leading: IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () {},
              color: Theme.of(context).accentColor,
            ),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              color: Theme.of(context).accentColor,
              onPressed: () {},
            ),
            backgroundColor: Colors.black87,
            title: Text(
              _product.title,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
