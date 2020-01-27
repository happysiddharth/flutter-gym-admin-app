import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/filters.dart';
import '../providers/products.dart';

import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);

    final filters = Provider.of<Filters>(context);

    var products = filters.all == true
        ? productsData.pendingFessUsers()
        : productsData.items;
    if (filters.on_hold_with_pendings == true && filters.all == false) {
      products = productsData.onHoldAndFessIsPending();
    } else if (filters.on_hold_with_no_pendings == true &&
        filters.all == false) {
      products = productsData.onHoldAndFessIsNotPending();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: UsersItem(productsData.token),
      ),
    );
  }
}
