import 'package:flutter/material.dart';
import 'package:mini_project_ty/snippets/navigator.dart';

Widget circle(BuildContext context, String img, Widget page) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: () {
        navi(context, page);
      },
      borderRadius: BorderRadius.circular(40),
      child: CircleAvatar(
        radius: 35,
        child: Image.asset(
          img,
          fit: BoxFit.fitWidth,
        ),
        backgroundColor: Colors.white,
      ),
    ),
  );
}
