import 'package:flutter/material.dart';

const validColor = Color.fromRGBO(39, 178, 116, 1);
const invalidColor = Color.fromRGBO(255, 128, 128, 1);
const initialColor = Color.fromRGBO(111, 145, 188, 1);
const focusEmptyColor = Color.fromRGBO(21, 29, 81, 1);
final borderRadius = BorderRadius.circular(10.0);

final emailRegex =
    RegExp(r'^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$', caseSensitive: false);

enum InputState { initial, error, passed }
