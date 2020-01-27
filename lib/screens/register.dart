import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../models/user.dart';
import 'dart:convert';
import './drawer.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _form = GlobalKey<FormState>();
  DateTime _choosen_date;
  var user = User(
    fullname: '',
    phone: '',
    email: '',
    address: '',
    state: '',
    pincode: '',
  );
  void _datepicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1974),
            lastDate: DateTime.now())
        .then((date) {
      if (date == null) {
        return;
      }
      setState(() {
        _choosen_date = date;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(_choosen_date);

    final products = Provider.of<Products>(context);
    Future<void> _show_resgistration_status() {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(
            'Success!',
            style: TextStyle(
                color: Colors.lightGreen, fontWeight: FontWeight.bold),
          ),
          content: Text('User is successfully registered!'),
          actions: <Widget>[
            FlatButton(
              child: Text('Done'),
              onPressed: () => {
                Navigator.of(context).pop(),
                Navigator.pushReplacementNamed(context, 'home'),
                _form.currentState.reset(),
              },
            )
          ],
        ),
      );
    }

    void _saveForm() {
      final isValid = _form.currentState.validate();
      if (!isValid) {
        return;
      }
      _form.currentState.save();
      products.addUser(user.fullname, user.phone, user.email, _choosen_date,
          user.address, user.state, user.pincode);
      _show_resgistration_status();
    }

    return Scaffold(
      drawer: Drawer(
        child: DrawerListTiles(),
      ),
      appBar: AppBar(
        title: Text('Register'),
        actions: <Widget>[],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Icon(
                      Icons.account_box,
                      size: 50,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Full name'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a name.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          user = User(
                              fullname: value.toString(),
                              phone: user.phone,
                              email: user.email,
                              address: user.address,
                              state: user.state,
                              pincode: user.pincode,
                              dob: user.dob,
                              id: user.id);
                        },
                      ),
                    )
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Icon(
                      Icons.phone,
                      size: 50,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(labelText: 'Mobile'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a mobile.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          user = User(
                              fullname: user.fullname,
                              phone: value,
                              email: user.email,
                              address: user.address,
                              state: user.state,
                              pincode: user.pincode,
                              dob: user.dob,
                              id: user.id);
                        },
                      ),
                    )
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Icon(
                      Icons.email,
                      size: 50,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(labelText: 'Email'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a email.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          user = User(
                              fullname: user.fullname,
                              phone: user.phone,
                              email: value,
                              address: user.address,
                              state: user.state,
                              pincode: user.pincode,
                              dob: user.dob,
                              id: user.id);
                        },
                      ),
                    )
                  ],
                ),
                Container(
                  width: double.infinity,
                  child: Column(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            size: 50,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: TextFormField(
                              decoration: InputDecoration(labelText: 'Address'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please provide a address.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                user = User(
                                    fullname: user.fullname,
                                    phone: user.phone,
                                    email: user.email,
                                    address: value,
                                    state: user.state,
                                    pincode: user.pincode,
                                    dob: user.dob,
                                    id: user.id);
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          SizedBox(
                            width: 55,
                          ),
                          Flexible(
                            child: TextFormField(
                              decoration: InputDecoration(labelText: 'State'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please provide a state.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                user = User(
                                    fullname: user.fullname,
                                    phone: user.phone,
                                    email: user.email,
                                    address: user.address,
                                    state: value,
                                    pincode: user.pincode,
                                    dob: user.dob,
                                    id: user.id);
                              },
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Flexible(
                            child: TextFormField(
                              keyboardType: TextInputType.numberWithOptions(),
                              decoration:
                                  InputDecoration(labelText: 'Pin code'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please provide a code.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                user = User(
                                    fullname: user.fullname,
                                    phone: user.phone,
                                    email: user.email,
                                    address: user.address,
                                    state: user.state,
                                    pincode: value,
                                    dob: user.dob,
                                    id: user.id);
                              },
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Icon(
                      Icons.cake,
                      size: 50,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        height: 50,
                        child: _choosen_date != null
                            ? Text(DateFormat.yMMMMd().format(_choosen_date))
                            : Text('choose any date'),
                      ),
                    ),
                    FlatButton(
                      child: Text('Pick date'),
                      onPressed: _datepicker,
                    )
                  ],
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  child: RaisedButton(
                    child: Text('Register'),
                    elevation: 6,
                    color: Colors.purple,
                    textColor: Colors.black,
                    onPressed: _saveForm,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
