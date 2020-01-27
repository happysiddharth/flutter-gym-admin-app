import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/selected_months.dart';
import '../providers/fess_data.dart';
import 'package:intl/intl.dart';
import '../providers/auth.dart';

class UsersItem extends StatefulWidget {
  final token;
  UsersItem(this.token);
  @override
  _UsersItemState createState() => _UsersItemState();
}

class _UsersItemState extends State<UsersItem> {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Product>(context);
    final fees_data = Provider.of<FessRecord>(context);
    final auth = Provider.of<Auth>(context);

    void _pay_fess(String id, String fullName, int month) {
      var paid_for_month;
      var amount_paid = 0;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Text('Pay fee of ${fullName.toUpperCase()}'),
          content: Text('Fess is pending from $month months'),
          actions: <Widget>[
            Container(
              width: 300,
              child: Column(
                children: <Widget>[
                  Text(
                    'Select months',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: 200,
                    child: Consumer<Months>(
                      builder: (_, months, child) => DropdownButton<String>(
                        items: List<String>.generate(
                                month, (i) => (i + 1).toString())
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          months.changeDate(value);
                          paid_for_month = value;
                        },
                        value: month < int.parse(months.selectedDate)
                            ? '1'
                            : paid_for_month = months.selectedDate,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Flexible(
                        child: TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Amount'),
                          onChanged: (val) {
                            amount_paid = int.parse(val);
                          },
                        ),
                      ),
                      FlatButton(
                        child: Text('PAY FEE'),
                        onPressed: () {
                          productsData.payment(
                              productsData.id,
                              productsData.fullName,
                              amount_paid,
                              int.parse(paid_for_month),
                              fees_data,
                              auth.l_email,
                              widget.token);

                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Card(
      elevation: 5,
      child: Container(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Container(
              child: SwitchListTile(
                title: Text('Put user on hold'),
                subtitle:
                    Text('Turning on this option will not increase the fess'),
                value: productsData.isOnHold,
                onChanged: (newValue) {
                  productsData.toggleIsPending(widget.token, productsData.id);
                },
              ),
            ),
            Divider(),
            Container(
              padding: EdgeInsets.all(5),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.account_circle),
                        Expanded(
                          child: Text(
                            productsData.fullName.toUpperCase(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                              'Fess pending from ${(DateTime.now().difference(productsData.lastFessPaidOn).inDays)} days '),
                          Text(
                              'Total paid till now ${productsData.amount_till_now != null ? productsData.amount_till_now : 0}'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        child: const Text('PAY FEE'),
                        onPressed: () {
                          _pay_fess(productsData.id, productsData.fullName,
                              productsData.pendingMonths);
                        },
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
