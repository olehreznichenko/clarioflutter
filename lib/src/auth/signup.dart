import 'package:clarioflutter/src/auth/HelperText.dart';
import 'package:clarioflutter/src/auth/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUp createState() => _SignUp();
}

class _SignUp extends State<SignUp> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  bool isFocused = true; // on mount autofocus email field
  bool isFocusedPassword = false;
  bool togglePassword = false;
  bool isSubmitting = false;

  Map<String, InputState> passwordErrorsMap = {
    "minLength": InputState.initial,
    "hasUpperLowerCase": InputState.initial,
    "hasNumber": InputState.initial,
  };
  InputState emailState = InputState.initial;

  @override
  void initState() {
    super.initState();
    emailFocusNode.addListener(onFocusChange);
    passwordFocusNode.addListener(onFocusChange);
  }

  void onFocusChange() {
    final value = emailController.text;

    if (!emailFocusNode.hasFocus) {
      if (value.isEmpty) {
        setState(() {
          emailState = InputState.error;
        });
      } else if (!emailRegex.hasMatch(value)) {
        setState(() {
          emailState = InputState.error;
        });
      } else {
        setState(() {
          emailState = InputState.passed;
        });
      }
    } else if (value.isEmpty) {
      setState(() {
        emailState = InputState.initial;
      });
    }

    setState(() {
      isFocused = emailFocusNode.hasFocus;
      isFocusedPassword = passwordFocusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    passwordController.dispose();
    emailController.dispose();
    emailFocusNode.removeListener(onFocusChange);
    passwordFocusNode.removeListener(onFocusChange);
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  void validatePassword(String value) {
    final errors = {
      "minLength": value.length > 7 && !value.contains(' ')
          ? InputState.passed
          : InputState.error,
      "hasUpperLowerCase":
          RegExp(r'[A-Z]').hasMatch(value) && RegExp(r'[a-z]').hasMatch(value)
              ? InputState.passed
              : InputState.error,
      "hasNumber":
          RegExp(r'\d').hasMatch(value) ? InputState.passed : InputState.error,
    };

    final result = errors.map((key, val) {
      if (val == InputState.error &&
          passwordErrorsMap[key] != InputState.initial) {
        return MapEntry(key, val);
      } else if (val == InputState.passed) {
        return MapEntry(key, val);
      }
      return MapEntry(key, passwordErrorsMap[key]!);
    });

    setState(() {
      passwordErrorsMap = result;
    });
  }

  isEvery(InputState value) {
    return passwordErrorsMap.entries.every((element) => element.value == value);
  }

  getColorByState() {
    final isInitial = isEvery(InputState.initial);
    final isError = isEvery(InputState.error);
    final isPassed = isEvery(InputState.passed);

    if (isInitial) {
      return initialColor;
    }

    if (isError) {
      return invalidColor;
    }
    if (isPassed) {
      return validColor;
    }

    return focusEmptyColor;
  }

  Future<void> onSubmit() async {
    if (emailState == InputState.passed && isEvery(InputState.passed)) {
      setState(() {
        isSubmitting = true;
      });
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        isSubmitting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Success')),
      );
      Navigator.pushNamed(context, '/', arguments: emailController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF4F9FF),
            Color(0xFFE0EDFB),
          ],
          stops: [0.0, 1.0],
          transform: GradientRotation(167.96 * (3.14159265359 / 180)),
        ),
      ),
      child: Stack(
        children: [
          SvgPicture.asset(
            'assets/images/background.svg',
            fit: BoxFit.contain,
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.bottomCenter,
          ),
          Center(
              child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Sign up',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A4E71),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    autofocus: true,
                    focusNode: emailFocusNode,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.email],
                    controller: emailController,
                    style: TextStyle(
                        color: emailState == InputState.initial
                            ? focusEmptyColor
                            : emailState == InputState.error
                                ? invalidColor
                                : validColor),
                    decoration: InputDecoration(
                      filled: true,
                      labelText: "Email",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: borderRadius,
                        borderSide: const BorderSide(
                          color: Color(0xFF6F91BC),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: borderRadius,
                        // borderSide: BorderSide.none,
                        borderSide:
                            (isFocused || emailController.text.isNotEmpty)
                                ? BorderSide(
                                    color: emailState == InputState.initial
                                        ? initialColor
                                        : emailState == InputState.error
                                            ? invalidColor
                                            : validColor,
                                  )
                                : BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: borderRadius,
                        borderSide: BorderSide(
                          color: emailState == InputState.initial
                              ? initialColor
                              : emailState == InputState.error
                                  ? invalidColor
                                  : validColor,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: borderRadius,
                        borderSide: const BorderSide(
                          color: Color(0xFFFF8080),
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: borderRadius,
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(21, 29, 81, 0.2),
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: borderRadius,
                        borderSide: const BorderSide(
                          color: Color(0xFFFF8080),
                        ),
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: passwordController,
                              obscureText: !togglePassword,
                              autofillHints: const [AutofillHints.password],
                              textInputAction: TextInputAction.done,
                              onChanged: validatePassword,
                              focusNode: passwordFocusNode,
                              style: TextStyle(color: getColorByState()),
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(togglePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  color: getColorByState(),
                                  onPressed: () {
                                    setState(() {
                                      togglePassword = !togglePassword;
                                    });
                                  },
                                ),
                                filled: true,
                                labelText: "Create your password",
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: borderRadius,
                                  borderSide: BorderSide(
                                    color: getColorByState(),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: borderRadius,
                                  borderSide: BorderSide.none,
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: borderRadius,
                                  borderSide: const BorderSide(
                                    color: Color.fromRGBO(21, 29, 81, 0.2),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: borderRadius,
                                  borderSide:
                                      BorderSide(color: getColorByState()),
                                ),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 10, 10, 10),
                              )),
                        ],
                      ),
                      const SizedBox(height: 10),
                      HelperText(
                        errorState: passwordErrorsMap['minLength']!,
                        message: '8 characters or more (no spaces)',
                      ),
                      HelperText(
                        errorState: passwordErrorsMap['hasUpperLowerCase']!,
                        message: 'Uppercase and lowercase letters',
                      ),
                      HelperText(
                        errorState: passwordErrorsMap['hasNumber']!,
                        message: 'At least one digit',
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 48,
                    width: 240,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF70C3FF),
                          Color(0xFF4B65FF),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: [0.1227, 0.9392],
                        transform:
                            GradientRotation(110.46 * (3.14159265359 / 180)),
                      ),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: ElevatedButton(
                      onPressed: isSubmitting ? null : onSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: Text(
                        isSubmitting ? 'Signing up...' : 'Sign up',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ))
        ],
      ),
    ));
  }
}
