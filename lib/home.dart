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

/// -----------------------------------
///           Home Widget
/// -----------------------------------

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

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

  Future<void> invokeApiAction(String capital) async {
    setState(() {
      isBusy = true;
      countries = null;
      errorMessage = null;
    });

    // Access token should not be empty by this point
    final String accessToken = await getAccessToken();

    final String url = '$API_CONTEXT_PATH$capital';
    final http.Response response = await http.get(
      url,
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        HttpHeaders.contentTypeHeader: ContentType.json.mimeType
      },
    );

    if (response.statusCode == 200) {
      // Decode response body and convert to country objects
      final List parsed =
          json.decode(response.body).cast<Map<String, dynamic>>();
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
