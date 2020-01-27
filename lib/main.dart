import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/products_overview_screen.dart';
import './screens/register.dart';
import './providers/products.dart';
import './providers/selected_months.dart';
import './providers/auth.dart';
import './screens/auth_screen.dart.dart';
import './models/filters.dart';
import './providers/fess_data.dart';
import './providers/search_toggle.dart';
import './screens/Transactions_Screen.dart';
import './screens/users_screen.dart';
import './screens/user_profile.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            update: (_, auth, previousState) => Products(auth.token),
          ),
          ChangeNotifierProvider.value(
            value: Filters(),
          ),
          ChangeNotifierProvider.value(
            value: Months(),
          ),
          ChangeNotifierProxyProvider<Auth, FessRecord>(
            update: (_, auth, previousState) => FessRecord(auth.token),
          ),
          ChangeNotifierProvider.value(
            value: SearchToggle(),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
              title: 'Spartans',
              theme: ThemeData(
                primarySwatch: Colors.purple,
                accentColor: Colors.deepOrange,
                fontFamily: 'Lato',
              ),
              home: auth.isAuth
                  ? ProductOverviewScreen()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (ctx, authResultSnapshot) =>
                          authResultSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? Container()
                              : AuthScreen(),
                    ),
              routes: {
                ProductOverviewScreen.route: (ctx) => ProductOverviewScreen(),
                'registration': (ctx) => Register(),
                'transaction': (ctx) => OrdersScreen(),
                Users.route: (ctx) => Users(),
                UserProfile.route: (ctx) => UserProfile(),
              }),
        ));
  }
}
//auth.isAuth ? ProductsOverviewScreen() :
