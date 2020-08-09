import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/SmartConstants.dart';
import '../widgets/SmartTextFormField.dart';

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
                  flex: 2,
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
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              bottom: 10,
                              right: 10,
                            ),
                            child: _getRichText(context),
                          ),
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
                            topPadding: 16,
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
                          const SizedBox(height: 16),
                          Center(
                            child: RaisedButton(
                              child: Text(
                                'LOGIN',
                                style: TextStyle(
                                  color: helper.isDarkModeActive
                                      ? Colors.black
                                      : Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                  fontSize: 20,
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(48),
                              ),
                              color: Theme.of(context).primaryColorDark,
                              elevation: 2,
                              padding: EdgeInsets.symmetric(
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
                          SizedBox(height: (helper.screenHeight-MediaQuery.of(context).padding.top)*0.05),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                text: 'Don\'t have an account?  ',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .color,
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
                                          helper.showSnackbarTextWithGlobalKey(
                                            _scaffoldKey,
                                            'Go to Signup!',
                                          );
                                        }),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
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
            fontFamily: 'ProductSans'),
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
