import 'package:flutter/material.dart';

/// -----------------------------------
///            Login Widget
/// -----------------------------------

class Login extends StatelessWidget {
  final Future<void> Function() loginAction;
  final String loginError;

  const Login(this.loginAction, this.loginError, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton.icon(
          color: Colors.orange,
          icon: Icon(Icons.account_circle),
          label: Text('Login to Cloud'),
          onPressed: () async {
            await loginAction();
          },
        ),
        Text(loginError ?? ''),
      ],
    );
  }
}
