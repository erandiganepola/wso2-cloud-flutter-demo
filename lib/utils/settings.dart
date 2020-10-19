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

import 'auth.dart';
import 'constants.dart';

/// Function to set tenant domain to secure storage
Future<String> setTenantDomain(String tenantDomain) async {
  await secureStorage.write(key: 'tenant_domain', value: tenantDomain);
}

/// Function to get tenant domain from secure storage
Future<String> getTenantDomain() async {
  String tenantDomain = await secureStorage.read(key: 'tenant_domain');
  if (tenantDomain == null || tenantDomain.isEmpty) {
    return TENANT_DOMAIN;
  }
  return tenantDomain;
}

/// Function to set client ID to secure storage
Future<String> setClientID(String clientID) async {
  await secureStorage.write(key: 'clientID', value: clientID);
}

/// Function to get client ID from secure storage
Future<String> getClientID() async {
  String clientID = await secureStorage.read(key: 'clientID');
  if (clientID == null || clientID.isEmpty) {
    return AUTH_CLIENT_ID;
  }
  return clientID;
}
