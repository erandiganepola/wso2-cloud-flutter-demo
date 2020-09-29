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
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'constants.dart';

final FlutterAppAuth flutterAppAuth = FlutterAppAuth();
const FlutterSecureStorage secureStorage = FlutterSecureStorage();

Future<String> login(
    String authDomain, String clientId, String redirectUri) async {
  try {
    // Creating auth service config for '/authorize' and '/token' endpoints
    final AuthorizationServiceConfiguration serviceConfiguration =
        AuthorizationServiceConfiguration('https://$authDomain/authorize',
            'https://$authDomain/token?tenantDomain=$TENANT_DOMAIN');

    // Call appAuth's authorize method to popup web browser with KM '/authorize'
    // KM will redirect the web browser to login page
    // Once logged in, KM redirects back to redirect URL with auth code
    // AppAuth internally generates code verifier and code challenge
    final AuthorizationResponse authorizationResponse =
        await flutterAppAuth.authorize(
      AuthorizationRequest(clientId, redirectUri,
          issuer: 'https://$authDomain',
          scopes: <String>['openid', 'profile', 'offline_access'],
          serviceConfiguration: serviceConfiguration),
    );

    debugPrint('Authorization request successful. Obtaining access token...');

    // Invoke '/token' endpoint with obtained authorizationCode and codeVerifier
    final TokenResponse tokenResponse = await flutterAppAuth.token(TokenRequest(
        clientId, redirectUri,
        serviceConfiguration: serviceConfiguration,
        authorizationCode: authorizationResponse.authorizationCode,
        codeVerifier: authorizationResponse.codeVerifier));

    debugPrint('Token request successful:${tokenResponse.accessToken}');

    await secureStorage.write(
        key: 'refresh_token', value: tokenResponse.refreshToken);
    await secureStorage.write(
        key: 'access_token', value: tokenResponse.accessToken);
    await secureStorage.write(key: 'id_token', value: tokenResponse.idToken);

    return tokenResponse.accessToken;
  } on Exception catch (e, s) {
    debugPrint('login error: $e - stack: $s');

    return null;
  }
}

Future<String> refreshAccessToken(
    {String clientId, String redirectUri, String issuer, String domain}) async {
  final String storedRefreshToken =
      await secureStorage.read(key: 'refresh_token');

  final AuthorizationServiceConfiguration serviceConfiguration =
      AuthorizationServiceConfiguration('https://$domain/authorize',
          'https://$domain/token?tenantDomain=vlgunarathne');

  final TokenResponse response = await flutterAppAuth.token(TokenRequest(
      clientId, redirectUri,
      issuer: issuer,
      refreshToken: storedRefreshToken,
      serviceConfiguration: serviceConfiguration));

  await secureStorage.write(key: 'refresh_token', value: response.refreshToken);
  await secureStorage.write(key: 'access_token', value: response.accessToken);

  return response.accessToken;
}

Future<String> getAccessToken() async {
  return secureStorage.read(key: 'access_token');
}
