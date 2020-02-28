import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/search_toggle.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import './drawer.dart';
import 'package:intl/intl.dart';
import './user_profile.dart';

class Users extends StatelessWidget {
  static String route = 'users';
  @override
  Widget build(BuildContext context) {
    final search_toggle = Provider.of<SearchToggle>(context);
    final users = Provider.of<Products>(context);

    void searchResult(String name) {
      search_toggle.add_string(name.toLowerCase());
    }

    List<Product> items = users.findByFullName(search_toggle.search_string);

    return Scaffold(
      appBar: search_toggle.search == false
          ? AppBar(title: Text('All users'), actions: <Widget>[
              IconButton(
                onPressed: () => search_toggle.toggle(),
                icon: Icon(
                  FontAwesomeIcons.search,
                  color: Colors.white,
                ),
              ),
            ])
          : AppBar(
              actions: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width - 170,
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width - 170,
                        child: TextField(
                          onChanged: (data) => searchResult(data),
                          autofocus: true,
                          decoration: const InputDecoration(
                            hintText: 'Search...',
                            border: InputBorder.none,
                            hintStyle: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: FlatButton.icon(
                    onPressed: () => search_toggle.toggle(),
                    label: Text(
                      'cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                    icon: Icon(
                      Icons.cancel,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
      drawer: Drawer(
        child: DrawerListTiles(),
      ),
      body: ListView.builder(
        itemBuilder: (_, i) => Container(
          padding: EdgeInsets.all(5),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    FlatButton.icon(
                      onPressed: () => Navigator.of(context)
                          .pushNamed(UserProfile.route, arguments: items[i].id),
                      icon: Icon(FontAwesomeIcons.user),
                      label: Text(
                        items[i].fullName.toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Icon(
                          Icons.phone,
                          size: 25,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5),
                        child: Text(
                          items[i].mobile,
                        ),
                      )
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: <Widget>[
                      Text('Joining date:'),
                      Spacer(),
                      Text(
                        DateFormat('dd-MMMM-yyyy').format(items[i].joinDate),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        itemCount: items.length,
      ),
    );
  }
}
