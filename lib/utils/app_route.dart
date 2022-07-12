import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppRoute {
  
  static Future<void> push({required BuildContext context, required Widget child}) async {
    if (Platform.isIOS) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => child));
    } else {
      Navigator.push(context, CupertinoPageRoute(builder: (context) => child));
    }
  }

  static void popup(BuildContext context) {
    Navigator.pop(context);
  }
}
