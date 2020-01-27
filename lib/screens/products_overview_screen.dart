import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/products_grid.dart';
import '../models/filters.dart';
import './drawer.dart';
import '../providers/products.dart';

class ProductOverviewScreen extends StatefulWidget {
  static String route = 'home';

  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchProduct().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  bool refresh = false;
  @override
  Widget build(BuildContext context) {
    bool isOneOn = false;
    void _show_filter() {
      showModalBottomSheet(
        context: context,
        builder: (_) {
          return Consumer<Filters>(
            builder: (_, filter, ch) => Container(
              decoration: BoxDecoration(color: Colors.transparent),
              child: Container(
                child: ListView(
                  children: <Widget>[
                    Text(
                      'Apply filters',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                    SwitchListTile(
                      title: Text(
                        'All',
                        style: TextStyle(color: Colors.black),
                      ),
                      value: filter.all,
                      onChanged: (value) => {filter.toggle('3')},
                    ),
                    Divider(),
                    SwitchListTile(
                      title: Text(
                        'On hold and fess is pending',
                        style: TextStyle(color: Colors.black),
                      ),
                      value: filter.on_hold_with_pendings,
                      onChanged: (value) => {filter.toggle('1')},
                    ),
                    Divider(),
                    SwitchListTile(
                      title: Text(
                        'On hold and all dues are cleared',
                        style: TextStyle(color: Colors.black),
                      ),
                      value: filter.on_hold_with_no_pendings,
                      onChanged: (value) => {filter.toggle('2')},
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    Future<Null> _refresh() async {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchProduct().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      return null;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Spartans'),
        actions: <Widget>[
          Padding(
            child: FlatButton.icon(
              icon: Icon(
                FontAwesomeIcons.filter,
                color: Colors.white,
              ),
              label: Text(
                'Filter',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: _show_filter,
            ),
            padding: EdgeInsets.all(10),
          ),
        ],
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
              child: Container(
                child: ProductsGrid(),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        backgroundColor: Colors.purple,
        onPressed: () => {Navigator.of(context).pushNamed('registration')},
      ),
    );
  }
}
