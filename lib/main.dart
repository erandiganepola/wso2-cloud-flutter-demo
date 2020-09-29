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

/// -----------------------------------
///                 App
/// -----------------------------------

void main() => runApp(const Wso2CloudFlutterDemo());

class Wso2CloudFlutterDemo extends StatefulWidget {
  const Wso2CloudFlutterDemo({Key key}) : super(key: key);

  @override
  _Wso2CloudFlutterDemoState createState() => _Wso2CloudFlutterDemoState();
}

/// -----------------------------------
///              App State
/// -----------------------------------

class _Wso2CloudFlutterDemoState extends State<Wso2CloudFlutterDemo> {
  bool isBusy = false;
  bool isLoggedIn = false;
  String errorMessage;
  String name;

  @override
  void initState() {
    initAction();
    super.initState();
  }

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
      debugPrint('error on refresh token: $e - stack: $s');
      await logoutAction();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (isBusy) {
      content = const CircularProgressIndicator();
    } else if (isLoggedIn) {
      content = const Home();
    } else {
      content = Login(loginAction, errorMessage);
    }

    return MaterialApp(
      title: 'WSO2 Cloud Flutter Demo',
      theme: ThemeData(
        // This is the theme of the application.
        primarySwatch: Colors.orange,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('WSO2 Cloud Flutter Demo'),
          actions: isLoggedIn
              ? <Widget>[
                  IconButton(
                    icon: const Icon(Icons.power_settings_new),
                    onPressed: () {
                      logoutAction();
                    },
                  ),
                ]
              : <Widget>[],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          child: content,
        ),
      ),
    );
  }

  Map<String, Object> parseIdToken(String idToken) {
    final List<String> parts = idToken.split('.');
    assert(parts.length == 3);

    return jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
  }

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

  Future<void> logoutAction() async {
    await secureStorage.delete(key: 'refresh_token');
    setState(() {
      isLoggedIn = false;
      isBusy = false;
    });
  }
}
