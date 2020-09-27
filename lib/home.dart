import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterdemo/utils/auth.dart';
import 'package:flutterdemo/utils/constants.dart';
import 'package:http/http.dart' as http;

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
  final textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Enter capital city',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter capital city';
              }
              return null;
            },
            controller: textController,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  invokeApiAction(textController.text);
                }
              },
              child: Text('Search'),
            ),
          ),
          isBusy
              ? const CircularProgressIndicator()
              : (countries != null && countries.length > 0)
                  ? ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: countries.length,
                      itemBuilder: (context, index) {
                        return CountryWidget(country: countries[index]);
                        // return ListTile(
                        // title: CountryWidget(country: countries[index]),
                        // title: Text(countries[index].name),
                        // );
                      })
                  //   ListView(
                  //               children: countries
                  //                   .map<CountryWidget>(
                  //                       (country) => CountryWidget(country: country))
                  //                   .toList(),
                  //             )
                  : Text('No results found!')
        ],
      ),
    );
  }

  Future<void> invokeApiAction(String capital) async {
    setState(() {
      isBusy = true;
      countries = null;
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

    // Decode response body and convert to country objects
    final List parsed = json.decode(response.body).cast<Map<String, dynamic>>();
    final List<Country> countryList =
        parsed.map<Country>((jsonObj) => Country.fromJson(jsonObj)).toList();

    setState(() {
      isBusy = false;
      countries = countryList;
    });
    debugPrint(
        'Got response: status: ${response.statusCode} -> ${response.body}');
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
        child: Column(children: <Widget>[
      Text('Country Name: ${country.name}'),
      Text('Capital: ${country.capital}'),
      Text('Region: ${country.region}'),
      Text('Population: ${country.population}')
    ]));
  }
}
