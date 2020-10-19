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

import 'home.dart';
import 'login.dart';

/// Main function to run app
void main() => runApp(const MainWidget());

/// Main widget -> Define the material app and routes.
class MainWidget extends StatelessWidget {
  const MainWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Return MaterialApp with routes
    return MaterialApp(
      title: "WSO2 Flutter Demo",
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Start the app with the "/login" named initial route.
      // In this case, the app starts on the Login widget.
      initialRoute: '/login',
      routes: {'/home': (context) => Home(), '/login': (context) => Login()},
    );
  }
}
