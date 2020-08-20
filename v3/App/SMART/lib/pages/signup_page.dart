import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';

import '../helpers/SmartHelper.dart';
import '../widgets/SmartTextFormField.dart';
import '../widgets/SmartCheckBox.dart';
import '../widgets/SmartCard.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _usernameController = TextEditingController();
  final _passController = TextEditingController();
  final _passConformController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  var _connectivitySubscription;

  bool _termsAccepted = true;
  bool _signupButtonEnabled = true;
  bool _showSpinner = false;

  @override
  void initState() {
    _connectivityMonitor();
    super.initState();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _usernameController.dispose();
    _passController.dispose();
    _passConformController.dispose();
    super.dispose();
  }

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 6,
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
                      left: 20, top: 0, right: 10, bottom: 8),
                  child: _getRichText(context),
                ),
                Expanded(
                  flex: 8,
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
                              bottomPadding: 0,
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
                              topPadding: 12,
                              bottomPadding: 0,
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
                            SmartTextFormField(
                              topPadding: 12,
                              bottomPadding: 0,
                              leftPadding: 10,
                              rightPadding: 10,
                              controller: _passConformController,
                              label: 'Confirm Password',
                              iconData: Icons.remove_red_eye,
                              hint: 'Re-type the above Password',
                              keyboardType: TextInputType.visiblePassword,
                              obscure: true,
                              helperText:
                                  'This Username & Password should be shared with your family so that they can also access the SMART devices.',
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
                const SizedBox(height: 8),
                Center(
                  child: SizedBox(
                    width: helper.screenWidth - 40,
                    child: SmartCard(
                      helper: helper,
                      elevation: 14,
                      cornerRadius: 14,
                      shadowColor: Theme.of(context).primaryColor,
                      blurRadius: SmartCardBlurRadius.Subtle,
                      child: RaisedButton(
                        child: !_showSpinner
                            ? Text(
                                'Create My Account',
                                style: TextStyle(
                                  color: helper.isDarkModeActive
                                      ? Colors.black
                                      : Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                  fontSize: 22,
                                ),
                              )
                            : CircularProgressIndicator(
                                backgroundColor: helper.isDarkModeActive
                                    ? Colors.black26
                                    : Colors.white,
                                valueColor: helper.isDarkModeActive
                                    ? AlwaysStoppedAnimation(Colors.black)
                                    : null,
                                semanticsLabel: 'Signing Up',
                              ),
                        color: Theme.of(context).primaryColorDark,
                        disabledColor:
                            Theme.of(context).primaryColorDark.withOpacity(0.3),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                        onPressed: _signupButtonEnabled
                            ? () {
                                !_showSpinner ? signupProcees(helper) : null;
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: helper.screenHeight * 0.025,
                    top: helper.screenHeight * 0.025,
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

  void signupProcees(SmartHelper helper) {
    if (_passConformController.text != _passController.text) {
      helper.showSnackbarTextWithGlobalKey(
          _scaffoldKey, "Password Mismatch! Try Again..");
      _passController.clear();
      _passConformController.clear();
    } else if (!_termsAccepted) {
      helper.showSnackbarTextWithGlobalKey(
          _scaffoldKey, "Please Accept the Terms & Conditions!");
    } else if (_formKey.currentState.validate()) {
      setState(() => _showSpinner = true);
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
        );
        currentUser.user.sendEmailVerification().then(
              (_) => helper.showSnackbarTextWithGlobalKey(
                _scaffoldKey,
                "Verification E-mail has been sent",
                onTimeout: () {
                  print('Snackbar Closed');
                  _usernameController.clear();
                  _passController.clear();
                  _passConformController.clear();
                  Navigator.of(context).pop();
                },
              ),
            );
        setState(() => _showSpinner = false);
      }).catchError(
        (e) {
          setState(() => _showSpinner = false);
          if (e is PlatformException) {
            if (e.toString().contains('WEAK'))
              helper.showSnackbarTextWithGlobalKey(
                _scaffoldKey,
                "Weak Password! Try Harder..",
              );
            else
              helper.showSnackbarTextWithGlobalKey(
                _scaffoldKey,
                "This E-mail is Already Registered!",
              );
          }
        },
      );
    }
  }

  void _connectivityMonitor() async {
    SmartHelper helper = SmartHelper(context: context);
    var con = await Connectivity().checkConnectivity();
    if (con == ConnectivityResult.none) {
      setState(() {
        _signupButtonEnabled = false;
        helper.showSnackbarTextWithGlobalKey(
          _scaffoldKey,
          'Internet Not Available!',
          persistent: true,
          dismissable: false,
        );
      });
    }
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.none)
        setState(() {
          _signupButtonEnabled = false;
          helper.showSnackbarTextWithGlobalKey(
            _scaffoldKey,
            'Error: No Internet Available!',
            persistent: true,
            dismissable: false,
          );
        });
      else
        setState(() {
          _signupButtonEnabled = true;
          _scaffoldKey.currentState.hideCurrentSnackBar();
        });
    });
  }
}
