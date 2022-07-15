import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:kurdivia/Screen/sponsorpage.dart';
import 'package:provider/provider.dart';

import '../Widgets/navigatebar.dart';
import '../constant.dart';
import '../provider/ApiService.dart';
import 'country.dart';

class Setting extends StatelessWidget implements ApiStatusLogin {
  Setting({Key? key}) : super(key: key);
  late BuildContext context;
  final phoneController = TextEditingController();
  final codeController = TextEditingController();
  String phone = '';
  var _lights = false;

  @override
  Widget build(BuildContext context) {
    context.read<ApiService>();
    this.context = context;
    return Scaffold(
        body: Consumer<ApiService>(builder: (context, value, child) {
      value.apiListener(this);
      return SafeArea(
          child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/1.jpg"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
                child: IconButton(
              onPressed: () {
                kNavigatorBack(context);
              },
              icon: Icon(Icons.arrow_back_ios),
            )),
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * .85,
                        height: MediaQuery.of(context).size.height * 0.06,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: MergeSemantics(
                          child: ListTile(
                            title: const Text('Notification',style: TextStyle(fontWeight: FontWeight.bold),),
                            trailing: CupertinoSwitch(
                              value: _lights,
                              onChanged: (bool val) {
                                _lights = val;
                                value.notifyListeners();
                              },
                            ),
                            onTap: () {
                              _lights = !_lights;
                              value.notifyListeners();
                            },
                          ),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * .85,
                        height: MediaQuery.of(context).size.height * 0.5,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('The best Quiz App'),
                            Image.asset('assets/images/medal.png'),
                          ],
                        )
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ));
    }));
  }

  @override
  void accountAvailable() {}

  @override
  void error() {
    ModeSnackBar.show(context, 'something go wrong', SnackBarMode.error);
  }

  @override
  void inputEmpty() {
    ModeSnackBar.show(
        context, 'username or password empty', SnackBarMode.warning);
  }

  @override
  void inputWrong() {
    ModeSnackBar.show(
        context, 'username or password incorrect', SnackBarMode.warning);
  }

  @override
  void login() {
    kNavigator(context, NavigateBar());
  }

  @override
  void passwordWeak() {
    ModeSnackBar.show(context, 'password is weak', SnackBarMode.warning);
  }
}
