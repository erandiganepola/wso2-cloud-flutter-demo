/// -----------------------------------
///          External Packages
/// -----------------------------------

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterdemo/home.dart';
import 'package:flutterdemo/login.dart';
import 'package:flutterdemo/utils/auth.dart';
import 'package:flutterdemo/utils/constants.dart';

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
          clientId: AUTH0_CLIENT_ID,
          redirectUri: AUTH0_REDIRECT_URI,
          issuer: AUTH0_ISSUER,
          domain: AUTH0_DOMAIN);

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
        resizeToAvoidBottomInset: false,
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
        body: Center(
            child: SingleChildScrollView(
          child: isBusy
              ? const CircularProgressIndicator()
              : isLoggedIn ? Home() : Login(loginAction, errorMessage),
        )),
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
        await login(AUTH0_DOMAIN, AUTH0_CLIENT_ID, AUTH0_REDIRECT_URI);

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
