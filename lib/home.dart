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
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'utils/auth.dart';
import 'utils/constants.dart';

/// Home widget
class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

/// Class to handle home page's state
class _HomeState extends State<Home> {
  bool isBusy = false;
  List<Country> countries;
  String errorMessage;
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
      contentElement = Text('Unable to fetch results: $errorMessage');
    } else {
      // When the user visits the home page for the first time, background
      // search icon is visible.
      contentElement = const Expanded(
          child: Icon(Icons.search, size: 150, color: Colors.grey));
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(children: <Widget>[
                Expanded(
                    flex: 1,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 5),
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

    // Sends a get request to configured API context URL with access token
    final String url = '$API_CONTEXT_PATH$capital';
    http.Response response = await http.get(
      url,
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        HttpHeaders.contentTypeHeader: ContentType.json.mimeType
      },
    );

    // If response's status code is 401, access token is expired. Hence call to
    // refreshAccessToken() function to and get a new access token.
    if (response.statusCode == 401) {
      final String accessToken = await refreshAccessToken(
          clientId: AUTH_CLIENT_ID,
          redirectUri: AUTH_REDIRECT_URI,
          issuer: AUTH_ISSUER,
          domain: AUTH_DOMAIN);
      debugPrint(
          'Got response: status: ${response.statusCode} -> ${response.body}');

      // Call API context URL with new access token
      response = await http.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
          HttpHeaders.contentTypeHeader: ContentType.json.mimeType
        },
      );
    }

    // If response's status code is 200, map response to Country objects.
    if (response.statusCode == 200) {
      // Decode response body and convert to country objects
      // We receive list of maps from response parsed
      final List parsed =
          json.decode(response.body).cast<Map<String, dynamic>>();
      // Converts every item in list to a country object.
      // Then get list of country objects
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
}

/// Class to set and get Country objects
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

/// Widget to draw country objects
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
