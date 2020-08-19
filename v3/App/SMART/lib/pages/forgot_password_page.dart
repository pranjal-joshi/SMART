import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:email_validator/email_validator.dart';

import '../helpers/SmartHelper.dart';
import '../controllers/SmartSharedPref.dart';
import '../Exceptions/SmartException.dart';

import '../widgets/SmartTextFormField.dart';
import '../widgets/SmartAppBar.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _usernameController = TextEditingController();
  final sp = SmartSharedPreference();
  SmartHelper helper;
  bool _showSpinner = false;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final _appBar = SmartAppBar(title: 'Forgot Password?');

  @override
  void initState() {
    sp.loadLoginCredentials().then((creds) {
      try {
        _usernameController.text = creds[0];
      } on RangeError {
        throw SmartException(SmartException.credentialNotFoundException);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    helper = SmartHelper(context: context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: _appBar,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            height: helper.screenHeight -
                _appBar.preferredSize.height -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).viewInsets.bottom,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Center(
                    child: Container(
                      width: helper.screenWidth * 0.7,
                      child: SvgPicture.asset(
                        'assets/images/forgot_password.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    top: 0,
                    right: 10,
                  ),
                  child: RichText(
                    text: TextSpan(
                      text: "Not a Problem!",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.7,
                        color: Theme.of(context).primaryColorDark,
                        fontFamily: 'ProductSans',
                      ),
                      children: [
                        TextSpan(
                          text: "\nLet's Reset",
                          style: TextStyle(
                            fontSize: 52,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: SmartTextFormField(
                          topPadding: 36,
                          bottomPadding: 36,
                          leftPadding: 20,
                          rightPadding: 20,
                          controller: _usernameController,
                          label: 'Username',
                          iconData: Icons.account_circle,
                          hint: 'Registered E-mail',
                          keyboardType: TextInputType.emailAddress,
                          validator: (String msg) {
                            if (msg.isEmpty)
                              return 'Need a Username to Reset!';
                            else if (!EmailValidator.validate(msg))
                              return 'Enter a valid E-mail!';
                            return null;
                          },
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          width: helper.screenWidth - 40,
                          child: RaisedButton(
                            child: !_showSpinner
                                ? Text(
                                    'RESET PASSWORD',
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
                                    semanticsLabel: 'Resetting Password',
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
                            onPressed: () =>
                                !_showSpinner ? _resetProcess() : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _resetProcess() async {
    if (_formKey.currentState.validate()) {
      var con = await Connectivity().checkConnectivity();
      if (con == ConnectivityResult.none) {
        helper.showSnackbarTextWithGlobalKey(
          _scaffoldKey,
          'Can\'t Connect to the Network!',
        );
        return;
      }
      setState(() => _showSpinner = true);
      print('Resetting Password!');
      FirebaseAuth.instance
          .sendPasswordResetEmail(email: _usernameController.text)
          .then((value) {
        setState(() => _showSpinner = false);
        helper.showSnackbarTextWithGlobalKey(
          _scaffoldKey,
          'Password Reset Link has been sent to E-mail',
        );
      }).catchError((e) {
        setState(() => _showSpinner = false);
        if (e.toString().contains('USER_NOT_FOUND')) {
          helper.showSnackbarTextWithGlobalKey(
            _scaffoldKey,
            'This E-mail is Not Registered!',
          );
        } else
          print(e);
      });
    }
  }
}
