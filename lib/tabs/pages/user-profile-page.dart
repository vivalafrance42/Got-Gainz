import 'package:fitness_app/pages/onboarding-builder.dart';
import 'package:fitness_app/ui/alert-dialog.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/services/shared-pref-helper.dart';
//import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auro_avatar/auro_avatar.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  SharedPreferences prefs;

  String _firstName;
  String _lastName;
  String _gender;
  String _motivation;
  int _heightFeet;
  int _heightInches;
  String _weight;

  @override
  void initState() {
    super.initState();
    _init();
    setData();
  }

  void _init() async {
    prefs = await SharedPreferences.getInstance();
  }

  void setData() async {
    SharedPreferencesHelper.getFirstName(prefs).then((firstName) {
      setState(() {
        this._firstName = firstName;
      });
    });
    SharedPreferencesHelper.getLastName(prefs).then((lastName) {
      setState(() {
        this._lastName = lastName;
      });
    });
    SharedPreferencesHelper.getGender(prefs).then((gender) {
      setState(() {
        this._gender = gender;
      });
    });
    SharedPreferencesHelper.getMotivation(prefs).then((motivation) {
      setState(() {
        _motivation = motivation;
      });
    });
    SharedPreferencesHelper.getHeight(prefs).then((height) {
      setState(() {
        this._heightFeet = height ~/ 12.0;
        this._heightInches = height % 12;
      });
    });
    SharedPreferencesHelper.getWeight(prefs).then((weight) {
      setState(() {
        _weight = weight;
      });
    });
  }

  Widget genderIcon() {
    if (_gender == 'Male') {
      return FaIcon(FontAwesomeIcons.mars);
    } else if (_gender == 'Female') {
      return FaIcon(FontAwesomeIcons.venus);
    } else {
      return FaIcon(FontAwesomeIcons.male);
    }
  }

  void alert(BuildContext context) {
    return ShowAlertDialog(
            cancelButtonToggle: true,
            mainButtonText: 'Continue',
            mainButtonOnPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Onboarding()),
                (Route<dynamic> route) => false,
              );
              SharedPreferencesHelper.setOnBoardingStatus(false, prefs);
            },
            alertTitle: 'WARNING',
            alertContent:
                'YOU WILL LOSE ALL DATA. THERE IS NO GOING BACK FROM THIS.')
        .showAlertDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    try {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            actions: <Widget>[
              MaterialButton(
                onPressed: () {
                  alert(context);
                },
                child: Text('Erase All Data'),
                textColor: Colors.white,
              ),
            ],
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purpleAccent,
                  Colors.deepPurple,
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InitialNameAvatar(
                  '${_firstName[0]} ${_lastName[0]}',
                  circleAvatar: true,
                  borderColor: Colors.orange,
                  borderSize: 10.0,
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.black,
                  padding: 20.0,
                  textSize: 30.0,
                ),
                SizedBox(height: 50.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(width: 15.0),
                    Text(
                      '$_firstName $_lastName',
                      style: TextStyle(
                        fontSize: 30.0,
                        letterSpacing: 1.5,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    genderIcon(),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text('About You'),
                Text(
                  _motivation,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                  width: 150.0,
                  child: Divider(
                    color: Colors.teal[900],
                  ),
                ),
                Card(
                  margin: EdgeInsets.symmetric(
                    vertical: 5.0,
                    horizontal: 100.0,
                  ),
                  child: ListTile(
                    title: Text(
                      '$_heightFeet feet $_heightInches inches',
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.symmetric(
                    vertical: 5.0,
                    horizontal: 100.0,
                  ),
                  child: ListTile(
                    title: Text(
                      _weight,
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      if (e != null) {
        return Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else {
        return null;
      }
    }
  }
}
