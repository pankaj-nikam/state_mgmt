import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_mgmt/providers/products_provider.dart';
import 'package:state_mgmt/widgets/side_drawer.dart';
import 'package:state_mgmt/widgets/user_product_item.dart';

import 'edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  Future<void> _refreshProduct(BuildContext ctx) {
    return Provider.of<Products>(ctx, listen: false).fetchAndSetProducts(true);
  }

  static const routeName = '/UserProductsScreen';
  @override
  Widget build(BuildContext context) {
    // final products = Provider.of<Products>(context ).items;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
      drawer: SideDrawer(),
      body: FutureBuilder(
        future: _refreshProduct(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () {
                      return _refreshProduct(context);
                    },
                    child: Consumer<Products>(
                      builder: (context, products, child) => Padding(
                        padding: const EdgeInsets.all(8),
                        child: ListView.separated(
                          separatorBuilder: (context, index) => Divider(),
                          itemCount: products.items.length,
                          itemBuilder: (_, index) =>
                              UserProductItem(products.items[index]),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
