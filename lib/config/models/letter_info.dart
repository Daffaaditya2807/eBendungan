import 'package:flutter/material.dart';

class LetterInfo {
  final String title;
  final DateTime createdAt;
  final Widget letterWidget;

  LetterInfo({
    required this.title,
    required this.createdAt,
    required this.letterWidget,
  });
}
