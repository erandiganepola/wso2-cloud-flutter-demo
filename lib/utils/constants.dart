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

/// Global Constants

// WSO2 API Cloud URL domain
const String AUTH_DOMAIN = 'gateway.api.cloud.wso2.com';

// Your client ID obtained by creating an application in WSO2 Store
const String AUTH_CLIENT_ID = 'fO0rk7lzuWZKRofN13zmZiQc7M8a';

// Call back URL specified in your application
const String AUTH_REDIRECT_URI = 'com.auth0.flutterdemo://login-callback';

// Auth token issuer domain
const String AUTH_ISSUER = 'https://$AUTH_DOMAIN';

// Your tenant domain
const String TENANT_DOMAIN = 'vlgunarathne';

// Full API context path (apart from URL param attached)
const String API_CONTEXT_PATH =
    'https://$AUTH_DOMAIN/t/$TENANT_DOMAIN/demo/v1.0/capital/';
