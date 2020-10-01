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

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'home.dart';
import 'login.dart';
import 'utils/auth.dart';
import 'utils/constants.dart';

final FlutterAppAuth appAuth = FlutterAppAuth();
const FlutterSecureStorage secureStorage = FlutterSecureStorage();

/// Main function to run app
void main() => runApp(const Wso2CloudFlutterDemo());

class Wso2CloudFlutterDemo extends StatefulWidget {
  const Wso2CloudFlutterDemo({Key key}) : super(key: key);

  @override
  _Wso2CloudFlutterDemoState createState() => _Wso2CloudFlutterDemoState();
}

/// Class to handle app state
class _Wso2CloudFlutterDemoState extends State<Wso2CloudFlutterDemo> {
  bool isBusy = false;
  bool isLoggedIn = false;
  String errorMessage;
  String name;

  /// Initialize app state
  @override
  void initState() {
    initAction();
    super.initState();
  }

  /// Set user logged in or not. Refresh access token if user has refresh token.
  Future<void> initAction() async {
    final String storedRefreshToken =
        await secureStorage.read(key: 'refresh_token');
    if (storedRefreshToken == null) return;

    setState(() {
      isBusy = true;
    });

    try {
      final String accessToken = await refreshAccessToken(
          clientId: AUTH_CLIENT_ID,
          redirectUri: AUTH_REDIRECT_URI,
          issuer: AUTH_ISSUER,
          domain: AUTH_DOMAIN);

      setState(() {
        isBusy = false;
        isLoggedIn = true;
      });
    } on Exception catch (e, s) {
      debugPrint('Error getting refresh token: $e - stack: $s');
      // If error occurs when refreshing access token during app initialization,
      // put the user to logged out state
      await logoutAction();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (isBusy) {
      content = const CircularProgressIndicator();
    } else if (isLoggedIn) {
      // If user logged in, navigate user to home page
      content = const Home();
    } else {
      // If user in logged out state, navigate user to login page
      content = Login(loginAction, errorMessage);
    }

    // Return material app with scaffold
    return MaterialApp(
      title: 'WSO2 Cloud Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('WSO2 Cloud Flutter Demo'),
          actions:
              isLoggedIn ? <Widget>[LogoutButton(logoutAction)] : <Widget>[],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          child: content,
        ),
      ),
    );
  }

  /// Parses retrieved ID token and returns the resulting Json object.
  Map<String, Object> parseIdToken(String idToken) {
    final List<String> parts = idToken.split('.');
    assert(parts.length == 3);

    return jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
  }

  /// Initializes user login and get the access token.
  Future<void> loginAction() async {
    setState(() {
      isBusy = true;
      errorMessage = '';
    });

    final String accessToken =
        await login(AUTH_DOMAIN, AUTH_CLIENT_ID, AUTH_REDIRECT_URI);

    if (accessToken != null) {
      setState(() {
        isBusy = false;
        isLoggedIn = true;
      });
    } else {
      setState(() {
        isBusy = false;
        isLoggedIn = false;
        errorMessage = 'Unable to login';
      });
    }
  }

  /// Logs out user and deletes refresh token from secure storage.
  Future<void> logoutAction() async {
    await secureStorage.delete(key: 'refresh_token');
    setState(() {
      isLoggedIn = false;
      isBusy = false;
    });
  }
}

/// Class to render logout button and logout confirmation dialog
class LogoutButton extends StatelessWidget {
  final Future<void> Function() logoutAction;

  const LogoutButton(this.logoutAction, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.power_settings_new),
      onPressed: () {
        // show the dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Logout"),
              content: const Text('Do you want to logout?'),
              actions: <Widget>[
                FlatButton(
                  child: Text("No"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Yes"),
                  onPressed: () async {
                    await logoutAction();
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
