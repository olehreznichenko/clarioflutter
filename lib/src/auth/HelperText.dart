import 'package:clarioflutter/src/auth/utils.dart';
import 'package:flutter/material.dart';

getColorByState(InputState errorState) {
  Color color;
  switch (errorState) {
    case InputState.passed:
      color = const Color.fromRGBO(39, 178, 116, 1);
      ;
      break;
    case InputState.error:
      color = const Color.fromRGBO(255, 128, 128, 1);
      ;
      break;
    default:
      color = const Color.fromRGBO(74, 78, 113, 1);
  }
  return color;
}

class HelperText extends StatelessWidget {
  final InputState errorState;
  final String message;

  const HelperText(
      {super.key, required this.errorState, required this.message});

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: TextStyle(color: getColorByState(errorState), fontSize: 13),
    );
  }
}
