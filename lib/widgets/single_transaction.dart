import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../models/fess.dart';

class OrderItem extends StatefulWidget {
  final Fess tnx;

  OrderItem(this.tnx);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 6,
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(5),
              child: Container(
                decoration: BoxDecoration(),
                child: Text(
                  '${widget.tnx.months} Months',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Divider(),
            ListTile(
              title: Row(
                children: <Widget>[
                  Text(
                    '${widget.tnx.fullname}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text(
                    'Rs.${widget.tnx.amount}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              subtitle: Text(
                DateFormat('dd-MMMM-yyyy  hh:mm')
                    .format(DateTime.parse(widget.tnx.date_of_submition)),
              ),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            if (_expanded)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                height: 50,
                child: Row(
                  children: <Widget>[
                    Text(
                      'Receiver:',
                      style: TextStyle(color: Colors.black38),
                    ),
                    Spacer(),
                    Text(widget.tnx.receiver.toString().toUpperCase()),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
