import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterdemo/utils/auth.dart';
import 'package:http/http.dart' as http;

/// -----------------------------------
///           Home Widget
/// -----------------------------------

class Home extends StatelessWidget {
  final String name;

  const Home(this.name, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 4),
              shape: BoxShape.circle),
        ),
        const SizedBox(height: 24),
        Text('Name: $name'),
        const SizedBox(height: 48),
        RaisedButton(
          onPressed: () async {
            await invokeApiAction();
          },
          child: const Text('Invoke API'),
        ),
      ],
    );
  }

  Future<void> invokeApiAction() async {
    // Access token should not be empty by this point
    final String accessToken = await getAccessToken();

    const String url =
        'https://gateway.api.cloud.wso2.com/t/vlgunarathne/demo/v1.0/currency/cop';
    final http.Response response = await http.get(
      url,
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        HttpHeaders.contentTypeHeader: ContentType.json.mimeType
      },
    );

    debugPrint(
        'Got response: status: ${response.statusCode} -> ${response.body}');
  }
}
