import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/fess_data.dart';
import '../screens/drawer.dart';
import '../widgets/single_transaction.dart';
import '../models/fess.dart';
import '../providers/fess_data.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<FessRecord>(context).transactions().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final feerecord = Provider.of<FessRecord>(context);
    List<Fess> items = feerecord.data;
    Future<Null> _refresh() async {
      setState(() {
        _isLoading = true;
      });
      Provider.of<FessRecord>(context).transactions().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      return null;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Past transactions'),
      ),
      drawer: Drawer(
        child: DrawerListTiles(),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _refresh,
              child: Consumer<FessRecord>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (ctx, i) => OrderItem(items[i]),
                ),
              ),
            ),
    );
  }
}
