import 'package:flutter/material.dart';

void navi(context, Widget page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void naviRep(context, Widget page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}
