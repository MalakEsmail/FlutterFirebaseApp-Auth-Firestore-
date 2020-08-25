import 'package:firebase_app/models/user.dart';
import 'package:firebase_app/services/database.dart';
import 'package:firebase_app/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:firebase_app/shared/constants.dart';
import 'package:provider/provider.dart';

class SettingForm extends StatefulWidget {
  @override
  _SettingFormState createState() => _SettingFormState();
}

class _SettingFormState extends State<SettingForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2'];
  String _currentName, _currentSugars;
  int _currentStrengths;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseServices(user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Text(
                      'Update Your brew Settings',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      initialValue: userData.name,
                      decoration: ktextInputDecoration,
                      validator: (val) {
                        return val.isEmpty ? 'Please Enter a name' : null;
                      },
                      onChanged: (val) {
                        setState(() {
                          _currentName = val;
                        });
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    //drop down
                    DropdownButtonFormField(
                        value: _currentSugars ?? userData.sugars,
                        items: sugars.map((sugar) {
                          return DropdownMenuItem(
                            value: sugar,
                            child: Text('$sugar sugars'),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _currentSugars = val;
                          });
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    Slider(
                      activeColor:
                          Colors.brown[_currentStrengths ?? userData.strength],
                      inactiveColor:
                          Colors.brown[_currentStrengths ?? userData.strength],
                      value: (_currentStrengths ?? 100).toDouble(),
                      onChanged: (val) {
                        setState(() {
                          _currentStrengths = val.round();
                        });
                      },
                      min: 100.0,
                      max: 900.0,
                      divisions: 8,
                    ),
                    //slider
                    RaisedButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          await DatabaseServices(user.uid).updateUserData(
                              _currentSugars ?? userData.sugars,
                              _currentName ?? userData.name,
                              _currentStrengths ?? userData.strength);
                        }
                        Navigator.pop(context);
                      },
                      color: Colors.pink[400],
                      child: Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ));
          } else {
            return Loading();
          }
        });
  }
}
