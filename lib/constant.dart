import 'package:flutter/material.dart';

const kDarkBlue = Color(0XFF6097B2);
const kLightBlue = Color(0XFF92dae6);
const kBlue1 = Color(0XFF3bdad5);
const kBlue2 = Color(0XFF13548a);
const kBlue3 = Color(0XFF13548a);

String kUser = 'Mohammad';

kNavigator(context, page) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => page),
  );
}
kNavigatorreplace(context, page) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => page),
  );
}

kNavigatorBack(context) {
  Navigator.of(context).pop();
}
