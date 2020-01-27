import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:provider/provider.dart';
import './drawer.dart';
import '../models/product.dart';
import '../providers/fess_data.dart';
import '../models/fess.dart';
import '../widgets/single_transaction.dart';

class UserProfile extends StatefulWidget {
  static String route = 'userProfile';
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool _show_tnx = false;
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
    final userId = ModalRoute.of(context).settings.arguments as String;
    final products = Provider.of<Products>(context);
    Product item = products.findById(userId);
    final transaction = Provider.of<FessRecord>(context);
    List<Fess> tnx = transaction.returnById(userId);
    void _show_transactions() {
      print('pressed');
      setState(() {
        _show_tnx = !_show_tnx;
      });
    }

    return Scaffold(
      drawer: Drawer(
        child: DrawerListTiles(),
      ),
      appBar: AppBar(
        title: Text(
          item.fullName.toUpperCase(),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 250,
                    child: Stack(
                      children: <Widget>[
                        Image.network(
                          'https://cdn-ami-drupal.heartyhosting.com/sites/muscleandfitness.com/files/styles/full_node_image_1090x614/public/media/7-Demonized-BodyBuilding-Food-Gallery.jpg',
                          fit: BoxFit.fill,
                        ),
                        Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 0.5)),
                            margin: EdgeInsets.only(
                              top: 166,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                item.fullName.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ))
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'Address',
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    item.address.toUpperCase(),
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(item.state.toUpperCase()),
                                    Text(','),
                                    Text(item.pinCode.toUpperCase()),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: <Widget>[
                            Text(
                              'Phone',
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                            Spacer(),
                            Text(item.mobile),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: <Widget>[
                            Text(
                              'Email',
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                            Spacer(),
                            item.email != null
                                ? Text(item.email)
                                : Text('Not registered'),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: <Widget>[
                            Text(
                              'DOB',
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                            Spacer(),
                            Text(
                              DateFormat('dd-MMMM-yyyy').format(item.dob),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  FlatButton(
                    child: _show_tnx == false
                        ? Text(
                            'show last payments'.toUpperCase(),
                            style: TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : Text(
                            'Hide last payments'.toUpperCase(),
                            style: TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                    onPressed: () => {
                      setState(() {
                        _show_tnx = !_show_tnx;
                      })
                    },
                  ),
                  if (_show_tnx == true)
                    tnx.length == 0
                        ? Container(
                            child: Text('no transaction yet'),
                          )
                        : Flexible(
                            child: ListView.builder(
                              itemCount: tnx.length,
                              itemBuilder: (ctx, i) => OrderItem(tnx[i]),
                            ),
                          ),
                ],
              ),
            ),
    );
  }
}
