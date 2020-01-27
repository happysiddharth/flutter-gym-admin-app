import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../screens/users_screen.dart';
import '../providers/auth.dart';

class DrawerListTiles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth_for_email = Provider.of<Auth>(context);
    return ListView(
      children: <Widget>[
        DrawerHeader(
          child: auth_for_email.l_email == null
              ? Text('')
              : Center(
                  child: Text(
                    auth_for_email.l_email.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
          decoration: BoxDecoration(
            color: Colors.purple,
          ),
        ),
        ListTile(
          leading: Icon(FontAwesomeIcons.home),
          title: Text(
            'Home',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed('/');

            // Navigator.of(context)
            //     .pushReplacementNamed(UserProductsScreen.routeName);
          },
        ),
        ListTile(
          leading: Icon(FontAwesomeIcons.users),
          title: Text(
            'Users',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(Users.route);

            // Navigator.of(context)
            //     .pushReplacementNamed(UserProductsScreen.routeName);
          },
        ),
        ListTile(
          leading: Icon(FontAwesomeIcons.moneyBill),
          title: Text(
            'Transaction',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed('transaction');

            // Navigator.of(context)
            //     .pushReplacementNamed(UserProductsScreen.routeName);
          },
        ),
        ListTile(
          leading: Icon(
            Icons.exit_to_app,
          ),
          title: Text(
            'Logout',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.of(context).pop();

            // Navigator.of(context)
            //     .pushReplacementNamed(UserProductsScreen.routeName);
            Provider.of<Auth>(context, listen: false).logout();
          },
        ),
      ],
    );
  }
}
