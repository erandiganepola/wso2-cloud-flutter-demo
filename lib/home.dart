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
import 'package:flutterdemo/utils/settings.dart';
import 'package:http/http.dart' as http;

import 'services/services.dart';
import 'utils/auth.dart';
import 'utils/constants.dart';

/// Home widget -> This widget contains and handles the country search by
/// capital
class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

/// Class to represent home page's state
class _HomeState extends State<Home> {
  bool isBusy = false;
  String errorMessage;
  String name;
  List<Country> countries;

  final TextEditingController textController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Widget contentElement;
    if (isBusy) {
      contentElement = const CircularProgressIndicator();
    } else if (countries != null && countries.isNotEmpty) {
      // If countries available for the searched capital,
      // draw a list view with a set of CountryWidgets
      contentElement = Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: countries.length,
              itemBuilder: (context, index) {
                return CountryWidget(country: countries[index]);
              }));
    } else if (errorMessage != null) {
      // Show the response error message if any.
      contentElement = Text('Unable to fetch results: $errorMessage');
    } else {
      // When the user visits the home page for the first time, background
      // search image is visible.
      contentElement = const Expanded(
          child: Icon(Icons.search, size: 150, color: Colors.grey));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('WSO2 Flutter Demo'),
        actions: <Widget>[SettingsButton(), LogoutButton(logoutAction)],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.center,
        child: isBusy
            ? const CircularProgressIndicator()
            : Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Row(children: <Widget>[
                          Expanded(
                              flex: 1,
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 5),
                                  hintText: 'Enter capital city',
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter a capital city';
                                  }
                                  return null;
                                },
                                controller: textController,
                              )),
                          IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              // When user clicks the search button, invokeApiAction() is
                              // called to get country search results for a given capital.
                              if (_formKey.currentState.validate()) {
                                invokeApiAction(textController.text);
                              }
                            },
                          )
                        ])),
                    contentElement,
                  ],
                ),
              ),
      ),
    );
  }

  /// Function to invoke API and get country search results for a given capital.
  Future<void> invokeApiAction(String capital) async {
    setState(() {
      isBusy = true;
      countries = null;
      errorMessage = null;
    });

    //Access token should not be empty by this point since user already loggedin
    final String accessToken = await getAccessToken();
    String tenantDomain = await getTenantDomain();

    http.Response response =
        await fetchCountries(tenantDomain, capital, accessToken);
    // If response's status code is 401, access token is expired. Hence call to
    // refreshAccessToken() function to get a new access token.
    if (response.statusCode == 401) {
      debugPrint(
          'Got response: status: ${response.statusCode} -> ${response.body}. '
          'Hence refresh access token!');

      final String accessToken = await refreshAccessToken(
          clientId: await getClientID(),
          redirectUri: AUTH_REDIRECT_URI,
          issuer: AUTH_ISSUER,
          domain: AUTH_DOMAIN);

      // Call API context URL with new access token
      response = await fetchCountries(tenantDomain, capital, accessToken);
    }

    // If response's status code is 200, map response to Country objects.
    if (response.statusCode == 200) {
      // Decode response body and convert to country objects.
      // We receive list of maps from response parsed.
      final List parsed =
          json.decode(response.body).cast<Map<String, dynamic>>();
      // Converts every item in list to a country object.
      // Then get list of country objects.
      final List<Country> countryList =
          parsed.map<Country>((jsonObj) => Country.fromJson(jsonObj)).toList();

      setState(() {
        isBusy = false;
        countries = countryList;
      });

      debugPrint(
          'Got response: status: ${response.statusCode} -> ${response.body}');
    } else {
      setState(() {
        isBusy = false;
        countries = null;
        errorMessage = response.body;
      });
    }
  }

  /// Log out user and delete refresh token from secure storage.
  Future<void> logoutAction() async {
    await clearRefreshToken();

    setState(() {
      isBusy = false;
    });

    await Navigator.pushNamedAndRemoveUntil(
        context, '/login', (route) => false);
  }
}

/// Class to keep a Country's attributes
class Country {
  final String name;
  final String capital;
  final String region;
  final int population;

  Country({this.name, this.capital, this.region, this.population});

  factory Country.fromJson(Map<String, dynamic> countryJson) {
    return Country(
        name: countryJson['name'],
        capital: countryJson['capital'],
        region: countryJson['region'],
        population: countryJson['population']);
  }
}

/// Widget to draw a country object
class CountryWidget extends StatelessWidget {
  final Country country;

  CountryWidget({this.country});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 2.0,
        child: Column(children: <Widget>[
          Text(
            country.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text('Capital: ${country.capital}'),
          Text('Region: ${country.region}'),
          Text('Population: ${country.population}')
        ]));
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
                  // If yes, logout use from app
                  onPressed: () async {
                    await logoutAction();
                    await Navigator.pushNamedAndRemoveUntil(
                        context, "/login", (route) => false);
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

/// Class to render settings button and configurations dialog
class SettingsButton extends StatelessWidget {
  SettingsButton({Key key}) : super(key: key);

  final GlobalKey<FormState> _settingsFormKey = GlobalKey<FormState>();
  final TextEditingController _clientIdFieldCon = TextEditingController();
  final TextEditingController _tenantDomainFieldCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.settings),
      onPressed: () async {
        _tenantDomainFieldCon.text = await getTenantDomain();
        _clientIdFieldCon.text = await getClientID();
        // show the dialog
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Update your configurations'),
              content: Form(
                key: _settingsFormKey,
                child: SingleChildScrollView(
                    child: ListBody(children: <Widget>[
                  TextFormField(
                    controller: _tenantDomainFieldCon,
                    textInputAction: TextInputAction.go,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(hintText: "Tenant Domain"),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your tenant domain';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _clientIdFieldCon,
                    textInputAction: TextInputAction.go,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(hintText: "Client ID"),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your client ID';
                      }
                      return null;
                    },
                  )
                ])),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: new Text('Update'),
                  onPressed: () async {
                    if (_settingsFormKey.currentState.validate()) {
                      debugPrint(
                          'Writing new configurations to secure storage: '
                          'Tenant Domain - ${_tenantDomainFieldCon.text}, '
                          'Client ID - ${_clientIdFieldCon.text}');
                      setTenantDomain(_tenantDomainFieldCon.text);
                      setClientID(_clientIdFieldCon.text);
                      Navigator.pop(context);
                    }
                  },
                )
              ],
            );
          },
        );
      },
    );
  }
}
