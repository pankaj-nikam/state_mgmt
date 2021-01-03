import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_mgmt/providers/product.dart';
import 'package:state_mgmt/providers/products_provider.dart';
import 'package:state_mgmt/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final Product _product;

  const UserProductItem(this._product);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(_product.imageUrl),
      ),
      title: Text(_product.title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName,
                    arguments: _product.id);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () {
                Provider.of<Products>(context, listen: false)
                    .deleteProduct(_product.id);
              },
            )
          ],
        ),
      ),
    );
  }
}
