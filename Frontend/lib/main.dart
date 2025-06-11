import 'dart:io';
import 'package:flutter/material.dart';
import 'package:projeect/aboutus.dart';
import 'package:projeect/analys.dart';
import 'package:projeect/analys2.dart';
import 'package:projeect/chat.dart';
import 'package:projeect/historypage.dart';
import 'package:projeect/homepage.dart';
import 'package:projeect/loginscreen2.dart';
import 'package:projeect/scanresult2.dart';
import 'package:projeect/camerapage.dart';
import 'package:projeect/profilepage.dart';
import 'package:projeect/scanresultpage.dart';
import 'package:projeect/settingpage.dart';
import 'package:projeect/splashview.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: LoginScreen2());
  }
}
