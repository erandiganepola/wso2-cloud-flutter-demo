/*
 * Copyright [2020] Erandi Ganepola All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:flutter/material.dart';
import 'package:flutterdemo/utils/auth.dart';
import 'package:flutterdemo/utils/constants.dart';

/// Login Widget -> Shows the login button and handles its click event.
class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isBusy = false;
  String errorMessage;

  /// Initialize app state
  @override
  void initState() {
    super.initState();
    initAction();
  }

  /// User loggedIn false by default. If user has a refresh token, get a new
  /// access token when initializing app and set loggedIn to true.
  Future<void> initAction() async {
    if (await getRefreshToken() == null) {
      return;
    }

    setState(() {
      isBusy = true;
    });

    try {
      await refreshAccessToken(
          clientId: AUTH_CLIENT_ID,
          redirectUri: AUTH_REDIRECT_URI,
          issuer: AUTH_ISSUER,
          domain: AUTH_DOMAIN);

      await navigateToHome();
    } on Exception catch (e, s) {
      debugPrint('Error refreshing token: $e - stack: $s');
    }

    setState(() {
      isBusy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('WSO2 Cloud Flutter Demo')),
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RaisedButton.icon(
                  color: Colors.orange,
                  icon: Icon(Icons.account_circle),
                  label: Text('Login to Cloud'),
                  // When user clicks login button, login action is being called.
                  onPressed: () async {
                    await loginAction();
                  },
                ),
                isBusy
                    ? const CircularProgressIndicator()
                    : Text(errorMessage ?? ''),
              ],
            )));
  }

  /// Initialize user login and get the access token.
  Future<void> loginAction() async {
    setState(() {
      isBusy = true;
      errorMessage = '';
    });

    // Call to get access token. If successful set isLoggedIn to true,
    // false otherwise.
    final String accessToken =
        await login(AUTH_DOMAIN, AUTH_CLIENT_ID, AUTH_REDIRECT_URI);

    if (accessToken != null) {
      setState(() {
        isBusy = false;
      });

      await navigateToHome();
    } else {
      setState(() {
        isBusy = false;
        errorMessage = 'Unable to login';
      });
    }
  }

  /// Navigates to home widget
  Future<void> navigateToHome() async {
    await Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }
}
