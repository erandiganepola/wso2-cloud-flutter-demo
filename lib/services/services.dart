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

import 'dart:io';

import 'package:flutterdemo/utils/constants.dart';
import 'package:http/http.dart' as http;

/// Function to send GET request to API context path and fetch country response
Future<http.Response> fetchCountries(
    String tenantDomain, String capital, String accessToken) async {
  // Full API context path (apart from URL param attached)
  String API_CONTEXT_PATH =
      'https://$AUTH_DOMAIN/t/$tenantDomain/demo/v1.0/capital/';
// Sends a get request to configured API context URL with access token
  final String url = '$API_CONTEXT_PATH$capital';
  http.Response response = await http.get(
    url,
    headers: <String, String>{
      'Authorization': 'Bearer $accessToken',
      HttpHeaders.contentTypeHeader: ContentType.json.mimeType
    },
  );
  return response;
}
