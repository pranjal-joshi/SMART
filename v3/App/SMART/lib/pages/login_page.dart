import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../controllers/SmartSharedPref.dart';
import '../helpers/SmartHelper.dart';
import '../exceptions/SmartException.dart';

import '../widgets/SmartTextFormField.dart';
import '../widgets/SmartCheckBox.dart';
import '../widgets/SmartCard.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  SmartHelper helper;
  final SmartSharedPreference sp = SmartSharedPreference();

  final _usernameController = TextEditingController();
  final _passController = TextEditingController();
  final _displayNameController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  bool _showSpinner = false;
  bool _rememberMe = true;

  @override
  void initState() {
    sp.loadLoginCredentials().then((creds) {
      try {
        _usernameController.text = creds[0];
        _passController.text = creds[1];
        _displayNameController.text = creds[2];
        setState(() {});
      } on RangeError {
        SmartException(SmartException.credentialNotFoundException);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    helper = SmartHelper(context: context);

    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            height: helper.screenHeight -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Center(
                    child: Container(
                      width: helper.screenWidth * 0.7,
                      child: SvgPicture.asset(
                        'assets/images/for_sale.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    top: 32,
                    right: 10,
                  ),
                  child: _getRichText(context),
                ),
                Expanded(
                  flex: 7,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SmartTextFormField(
                              topPadding: 18,
                              bottomPadding: 0,
                              leftPadding: 10,
                              rightPadding: 10,
                              controller: _displayNameController,
                              label: 'Your Name',
                              iconData: Icons.account_circle,
                              hint: 'Name to Display',
                              keyboardType: TextInputType.name,
                              validator: (String msg) {
                                if (msg.isEmpty) return 'What\'s your name?';
                                return null;
                              },
                            ),
                            SmartTextFormField(
                              topPadding: 18,
                              bottomPadding: 0,
                              leftPadding: 10,
                              rightPadding: 10,
                              controller: _usernameController,
                              label: 'Username',
                              iconData: Icons.account_circle,
                              hint: 'Registered E-mail',
                              keyboardType: TextInputType.emailAddress,
                              validator: (String msg) {
                                if (msg.isEmpty)
                                  return 'Need a Username to Login!';
                                else if (!EmailValidator.validate(msg))
                                  return 'Enter a valid E-mail!';
                                return null;
                              },
                            ),
                            SmartTextFormField(
                              topPadding: 18,
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
                                  return 'Uh-oh! Password can\'t be blank!';
                                return null;
                              },
                            ),
                            Center(
                              child: SizedBox(
                                width: helper.screenWidth * 0.65,
                                child: SmartCheckBox(
                                  padding: const EdgeInsets.only(left: 10),
                                  initialValue: _rememberMe,
                                  title: 'Remember Me',
                                  onChange: (bool val) => _rememberMe = val,
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
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: RichText(
                      text: TextSpan(
                          text: "Forgot Password?",
                          style: TextStyle(
                            color: Theme.of(context).textTheme.subtitle1.color,
                            fontSize: 18,
                            fontFamily: 'ProductSans',
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context)
                                  .pushNamed(route_forgot_pass);
                            }),
                    ),
                  ),
                ),
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
                                'LOGIN',
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
                                semanticsLabel: 'Logging In',
                              ),
                        color: Theme.of(context).primaryColorDark,
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                        onPressed: () => !_showSpinner ? _loginProcess() : null,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: helper.screenHeight * 0.03,
                    top: helper.screenHeight * 0.02,
                  ),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Don\'t have an account?  ',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.subtitle1.color,
                          fontSize: 18,
                          fontFamily: 'ProductSans',
                        ),
                        children: [
                          TextSpan(
                            text: "Sign up!",
                            style: TextStyle(
                              color: Theme.of(context).primaryColorDark,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).pushNamed(route_signup);
                              },
                          ),
                        ],
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
        text: "Smartify the",
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.7,
          color: Theme.of(context).primaryColorDark,
          fontFamily: 'ProductSans',
        ),
        children: [
          TextSpan(
            text: "\nFuture",
            style: TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  void _loginProcess() async {
    if (_formKey.currentState.validate()) {
      final network = await Connectivity().checkConnectivity();
      if (network == ConnectivityResult.none) {
        helper.showSnackbarTextWithGlobalKey(
          _scaffoldKey,
          'Can\'t Connect to the Network!',
        );
        return;
      }
      setState(() => _showSpinner = true);
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: _usernameController.text,
        password: _passController.text,
      )
          .then((currentUser) {
        if (!currentUser.user.isEmailVerified) {
          currentUser.user.sendEmailVerification().then(
                (_) => helper.showSnackbarTextWithGlobalKey(
                  _scaffoldKey,
                  "Verify this Email to Continue!",
                ),
              );
          setState(() => _showSpinner = false);
        } else {
          Firestore.instance
              .collection('users')
              .document(currentUser.user.uid)
              .get()
              .then(
            (DocumentSnapshot result) {
              sp.saveLoginState(true);
              setState(() => _showSpinner = false);
              if (_rememberMe)
                sp.saveLoginCredentials(
                  [
                    _usernameController.text,
                    _passController.text,
                    _displayNameController.text,
                  ],
                );
              Navigator.of(context).pushReplacementNamed(route_home);
            },
          ).catchError((e) => print('Err 1 = $e'));
        }
      }).catchError((e) {
        sp.saveLoginState(false);
        if (e.toString().contains('WRONG_PASSWORD')) {
          helper.showSnackbarTextWithGlobalKey(
            _scaffoldKey,
            'Username/Password Incorrect!',
          );
        } else if (e.toString().contains('NETWORK')) {
          helper.showSnackbarTextWithGlobalKey(
            _scaffoldKey,
            'Couldn\'t Reach the Server at the moment!',
          );
        } else if (e.toString().contains('USER_NOT_FOUND')) {
          helper.showSnackbarTextWithGlobalKey(
            _scaffoldKey,
            'Sign-up with this E-mail to register',
          );
        } else if (e.toString().contains('TOO_MANY_REQUESTS')) {
          helper.showSnackbarTextWithGlobalKey(
            _scaffoldKey,
            'Login Blocked due to Multiple Attempts! Try Later!',
          );
        }
        print(e);
        setState(() => _showSpinner = false);
      });
    }
  }
}
