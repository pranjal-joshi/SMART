import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/SmartConstants.dart';
import '../widgets/SmartTextFormField.dart';
import '../widgets/SmartCheckBox.dart';

class SignupPage extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _passController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  bool _termsAccepted = false;

  @override
  Widget build(BuildContext context) {
    final SmartHelper helper = SmartHelper(context: context);

    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            height: helper.screenHeight - MediaQuery.of(context).padding.top,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Container(
                      width: helper.screenWidth * 0.7,
                      child: SvgPicture.asset(
                        'assets/images/home_settings.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10, top: 32, right: 20, bottom: 8),
                  child: _getRichText(context),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SmartTextFormField(
                              topPadding: helper.screenHeight * 0.02,
                              bottomPadding: 8,
                              leftPadding: 10,
                              rightPadding: 10,
                              controller: _usernameController,
                              label: 'E-mail',
                              iconData: Icons.account_circle,
                              keyboardType: TextInputType.emailAddress,
                              validator: (String msg) {
                                if (msg.isEmpty)
                                  return 'E-mail required for sign-up!';
                                else if (!EmailValidator.validate(msg))
                                  return 'Please enter a valid E-mail';
                                return null;
                              },
                            ),
                            SmartTextFormField(
                              topPadding: 20,
                              bottomPadding: 8,
                              leftPadding: 10,
                              rightPadding: 10,
                              controller: _passController,
                              label: 'Password',
                              iconData: Icons.security,
                              keyboardType: TextInputType.visiblePassword,
                              obscure: true,
                              validator: (String msg) {
                                if (msg.isEmpty)
                                  return 'Can\'t proceed without Password!';
                                return null;
                              },
                            ),
                            Center(
                              child: SizedBox(
                                width: helper.screenWidth * 0.65,
                                child: SmartCheckBox(
                                  padding: const EdgeInsets.only(left: 10),
                                  initialValue: _termsAccepted,
                                  title: 'I Agree the T&Cs',
                                  onChange: (bool val) {
                                    _termsAccepted = val;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: SizedBox(
                    width: helper.screenWidth - 40,
                    child: RaisedButton(
                      child: Text(
                        'Create My Account',
                        style: TextStyle(
                          color: helper.isDarkModeActive
                              ? Colors.black
                              : Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          fontSize: 22,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      color: Theme.of(context).primaryColorDark,
                      elevation: 8,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 16,
                      ),
                      onPressed: () => signupProcees(helper),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: helper.screenHeight * 0.05,
                    top: helper.screenHeight * 0.03,
                  ),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Terms & Conditions',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.subtitle1.color,
                          decoration: TextDecoration.underline,
                          fontSize: 18,
                          fontFamily: 'ProductSans',
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            print('Open T&C');
                          },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  RichText _getRichText(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "Let\'s Get You",
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.7,
          color: Theme.of(context).primaryColorDark,
          fontFamily: 'ProductSans',
        ),
        children: [
          TextSpan(
            text: "\nOnboard",
            style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                height: 1.1),
          ),
        ],
      ),
    );
  }

  // Register user to Firebase
  void signupProcees(SmartHelper helper) {
    if (_formKey.currentState.validate()) {
      helper.showSnackbarTextWithGlobalKey(
        _scaffoldKey,
        'Signing Up...',
      );
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _usernameController.text,
        password: _passController.text,
      )
          .then((currentUser) {
        Firestore.instance
            .collection('users')
            .document(currentUser.user.uid)
            .setData(
          {
            'uid': currentUser.user.uid,
            'username': _usernameController.text,
            'password': _passController.text,
          },
        ).then((result) {
          helper.showSnackbarTextWithGlobalKey(
            _scaffoldKey,
            "Signup Completed!",
          );
          _usernameController.clear();
          _passController.clear();
        }).catchError(
          (e) => print(e),
        );
      }).catchError(
        (e) => print(e),
      );
    }
  }
}
