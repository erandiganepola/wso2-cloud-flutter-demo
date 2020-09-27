import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final FlutterAppAuth appAuth = FlutterAppAuth();
const FlutterSecureStorage secureStorage = FlutterSecureStorage();

Future<String> login(String domain, String clientId, String redirectUri) async {
  try {
    final AuthorizationServiceConfiguration serviceConfiguration =
        AuthorizationServiceConfiguration('https://$domain/authorize',
            'https://$domain/token?tenantDomain=vlgunarathne');

    final AuthorizationResponse authorizationResponse = await appAuth.authorize(
      AuthorizationRequest(clientId, redirectUri,
          issuer: 'https://$domain',
          scopes: <String>['openid', 'profile', 'offline_access'],
          serviceConfiguration: serviceConfiguration
          // promptValues: ['login']
          ),
    );

    debugPrint('Authorization request successful. Obtaining access token...');

    final TokenResponse tokenResponse = await appAuth.token(TokenRequest(
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

  final TokenResponse response = await appAuth.token(TokenRequest(
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
