import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/SmartConstants.dart';
import '../widgets/SmartTextFormField.dart';
import '../widgets/SmartCheckBox.dart';

class LoginPage extends StatelessWidget {
  SmartHelper helper;
  final _usernameController = TextEditingController();
  final _passController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    helper = SmartHelper(context: context);

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
                  flex: 3,
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
                  flex: 3,
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
                              topPadding: 24,
                              bottomPadding: 8,
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
                                  return 'Uh-oh! Password can\'t be blank!';
                                return null;
                              },
                            ),
                            Center(
                              child: SizedBox(
                                width: helper.screenWidth * 0.65,
                                child: SmartCheckBox(
                                  padding: const EdgeInsets.only(left: 10),
                                  initialValue: true,
                                  title: 'Remember Me',
                                  onChange: (bool val) {
                                    print(val.toString());
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
                        'LOGIN',
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
                      onPressed: () {
                        helper.showSnackbarTextWithGlobalKey(
                          _scaffoldKey,
                          'Logging In...',
                        );
                        _formKey.currentState.validate();
                      },
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
                height: 1.1),
          ),
        ],
      ),
    );
  }
}
