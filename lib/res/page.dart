import 'package:flutter/material.dart';

Scaffold bodyApp({Widget? child, AppBar? appbar}) {
  return Scaffold(
    appBar: appbar,
    backgroundColor: Colors.white,
    body: SafeArea(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: child,
    )),
  );
}
