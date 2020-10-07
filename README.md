# Securely consuming WSO2 API Cloud APIs with Flutter

### Content
- [Introduction](https://github.com/erandiganepola/wso2-cloud-flutter-demo#introduction)
- [Problem](https://github.com/erandiganepola/wso2-cloud-flutter-demo#problem)
- [Solution](https://github.com/erandiganepola/wso2-cloud-flutter-demo#solution)
  - [Choosing recommended security standards](https://github.com/erandiganepola/wso2-cloud-flutter-demo#choosing-recommended-security-standards)
  - [Choosing a cross platform mobile application framework](https://github.com/erandiganepola/wso2-cloud-flutter-demo#choosing-a-cross-platform-mobile-application-framework)
  - [Implementing security and more](https://github.com/erandiganepola/wso2-cloud-flutter-demo#implementing-security-and-more)
- [Setup your Environment](https://github.com/erandiganepola/wso2-cloud-flutter-demo#setup-your-environment)
  - [Project Setup](https://github.com/erandiganepola/wso2-cloud-flutter-demo#project-setup)
  - [Prerequisites to setup in WSO2 Cloud](https://github.com/erandiganepola/wso2-cloud-flutter-demo#prerequisites-to-setup-in-wso2-cloud)
  - [Run the Application](https://github.com/erandiganepola/wso2-cloud-flutter-demo#run-the-application)
  - [Login, Invoke API and Logout](https://github.com/erandiganepola/wso2-cloud-flutter-demo#login-invoke-api-and-logout)
- [Implementation](https://github.com/erandiganepola/wso2-cloud-flutter-demo#implementation)
- [What's Next](https://github.com/erandiganepola/wso2-cloud-flutter-demo#whats-next)

## Introduction

With mobile revolution, businesses tend to provide their products and services via mobile applications apart from the conventional web applications. Mobile applications provide faster access, portability, frequent customer engagement and many more as advantages.

When developing mobile applications, technology stack, security and usability are the main concerns. The “write once, run anywhere” approach that comes with cross platform  applications allows developers to utilize a single code on multiple platforms, which greatly reduces costs and shortens the development time , unlike native apps.

When invoking APIs securely, shipping credentials/access tokens (ex: client-secrets) with the application is not recommended because they can be easily exposed. The proposed approach is using [authorization code grant type](https://is.docs.wso2.com/en/latest/learn/authorization-code-grant/) which authenticates with an authorization server using a combination of client-id and authorization code. But then again authorization code can be intercepted. Therefore the recommended way for mobile applications is ['authorization code grant with proof key for code exchange'](https://is.docs.wso2.com/en/5.9.0/learn/try-authorization-code-grant/). Refer the [RFC-7636 spec](https://tools.ietf.org/html/rfc7636) on Proof Key for Code Exchange (PKCE) by OAuth Public Clients for more details.

In this project, we have written a [Flutter](https://flutter.dev/) mobile application which securely invokes an API through [WSO2 API Cloud](https://wso2.com/api-management/cloud/) using authorization code grant with PKCE .

## Problem

We need to write a novel cross platform (iOS/Android) mobile application which uses single sign on (SSO) and securely invokes an existing API to reach a wider audience while providing them ease of access. Implementing recommended security standards like authorization code grant with PKCE ourselves is time consuming. 

## Solution

- ### Choosing recommended security standards
As discussed in the introduction, when developing SSO mobile applications securely, authorization code grant with PKCE flow is recommended to mitigate the effects of authorization code interception attacks. Therefore PKCE will make authorization flow more secure by providing a way to generate a code-verifier and code challenge that are used when requesting the access token so that an attacker who intercepts the authorization code can’t make use of the stolen authorization-code.

- ### Choosing a cross platform mobile application framework
[Flutter](https://flutter.dev/) and [React Native](https://reactnative.dev) frameworks are the leading contenders while React Native is more matured and Flutter is better in performance with more support for native components. Experts have predicted that Flutter will be the future of mobile application development. Furthermore Flutter has an 'AppAuth' library named ['flutter_appauth'](https://pub.dev/packages/flutter_appauth) which handles the 'authorization code with PKCE' flow. Considering those reasons and after comparing both frameworks, we decided to use Flutter to develop this mobile application. Please refer this article for more details on [Flutter vs React Native vs Native Comparison](https://medium.com/swlh/flutter-vs-react-native-vs-native-deep-performance-comparison-990b90c11433)

Flutter framework uses Google's [Dart](https://dart.dev) language. It is used to develop for multiple platforms such as mobile, desktop, server, and web applications.

- ### Implementing security and more
We earlier mentioned that implementing security standards by ourselves is time consuming. Additionally monitoring, throttling and may be API monetization are required to be handled. In summary we need a matured API Management solution. 

When considering the above factors, [WSO2 API Cloud](https://wso2.com/api-management/cloud/) is the most suitable solution. Refer this article for more details - [A Guide to Selecting the Right API Management SaaS](https://wso2.com/blogs/thesource/a-guide-to-selecting-the-right-api-management-saas/)


So in this project we will develop an application which demonstrates how a consumer can write a mobile application to consume APIs securely with WSO2 API Cloud.

## Setup your Environment
Development Environment, one of:
- [Android Studio](https://developer.android.com/studio), or
- [IntelliJ IDEA](https://www.jetbrains.com/idea/download/#section=linux), or
- [Visual Studio Code](https://code.visualstudio.com/download)

These IDEs integrate well with Flutter. You will need an installation of the Dart and Flutter plugins, regardless of the IDE you decide to use.

Next download and install Flutter [SDK](https://flutter.dev/docs/get-started/install) and set path in your '.bashrc' file and source it.

- ### Project Setup

  - Clone project.

  - In this project you will use three main dependencies. Those are 'http', 'flutter_appauth' and 'flutter_secure_storage'. Refer [official documentation](https://auth0.com/blog/get-started-with-flutter-authentication/#Install-Dependencies) for more information on these dependencies.

  - Install dependencies by clicking "Pub get" in your IDE or run the following command in the project root:

```bash
flutter pub get
```

- ### Prerequisites to setup in WSO2 Cloud
  - Create an account in WSO2 Cloud if you don't have one and login to [Publisher portal](https://api.cloud.wso2.com/publisher).
  - [Create an API](https://docs.wso2.com/display/APICloud/Create+and+Publish+an+API). When creating your API, add a "GET" method for the resource path "/capital/{capital}" and set the endpoint URL to "https://restcountries.eu/rest/v2". At the end your API should call [REST Countries Capital City endpoint](https://restcountries.eu/#api-endpoints-capital-city). Then publish your API.
  - Visit WSO2 API Store and [create an application](https://docs.wso2.com/display/APICloud/Subscribe+to+and+Invoke+an+API). Enable code grant with a redirect URL (ex: org.wso2.cloud.flutterdemo://login-callback) and generate tokens.
  - Subscribe to previously published API from the newly created application.
  - Signin to [WSO2 Keymanager](https://keymanager.api.cloud.wso2.com/carbon/) by giving username as 'youruser@email.com@tenant' and give your password. Then enable [Allow "Authentication without client secret" configuration under the OIDC service provider config](https://is.docs.wso2.com/en/latest/learn/configuring-oauth2-openid-connect-single-sign-on/).
  - Set relevant values in cloned project's 'lib/utils/constants.dart' file. Sample is given below:
  
```dart
/// Global Constants

// WSO2 API Cloud URL domain
const String AUTH_DOMAIN = 'gateway.api.cloud.wso2.com';

// Your client ID obtained by creating an application in WSO2 Store
const String AUTH_CLIENT_ID = 'fO0rk7lzuWZKRofN13zmZiQc7M8a';

// Call back URL specified in your application
const String AUTH_REDIRECT_URI = 'org.wso2.cloud.flutterdemo://login-callback';

// Auth token issuer domain
const String AUTH_ISSUER = 'https://$AUTH_DOMAIN';

// Your tenant domain
const String TENANT_DOMAIN = 'vlgunarathne';

// Full API context path (apart from URL param attached)
const String API_CONTEXT_PATH =
    'https://$AUTH_DOMAIN/t/$TENANT_DOMAIN/demo/v1.0/capital/';
```

- ### Run the Application

To run the application you have two options. Either to run in your mobile application or to run in a simulator.

  - Option 01 : [Enable developer options and USB Debugging](https://www.howtogeek.com/129728/how-to-access-the-developer-options-menu-and-enable-usb-debugging-on-android-4.2/#:~:text=To%20enable%20Developer%20Options%2C%20open,times%20to%20enable%20Developer%20Options.) in mobile phone’s settings and run the application.
  - Option 02 : Launch either the [iOS simulator](https://flutter.dev/docs/get-started/install/macos#set-up-the-ios-simulator) or [Android emulators](https://flutter.dev/docs/get-started/install/macos#set-up-the-android-emulator), then run the application. 
  - You can run the application from your IDE or using following command:

```bash
flutter run -d all
```
- ### Login, Invoke API and Logout

After running the application, UI will be popped out with a button to 'Login to WSO2 Cloud'. Once user clicks it, s/he will be navigated to WSO2 authorization login page. There user needs to enter username as `youruser@email.com@tenant` and give password. Then approve access to user profile information. When it's successful, user will be directed to Home page. There you can enter a capital of a country and click search icon in the right side of the search box. You will see results in the UI. 

If user needs to sign out, click 'power button' in the top bar right side corner. Then confirmation box will be popped up. When you click `Yes` it will log out user from the application.

## Implementation

First let's identify the flow of this scenario. We can devide the complete flow in to four sub flows mainly.

- Login and token generation
- API invocation with a valid access token
- API invocation with an invalid access token (refreshing access token)
- Logout

Now let's go through above flows one by one in detail.

- ### Login and token generation

<img src="https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/resources/images/DiagramLogin_%20tokenGeneration.jpg" alt="Your image title" height="600" width="1200"/>

When user opens this mobile application, user is navigated to the `Login` page as below:

<img src="https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/resources/images/login.jpeg" alt="Your image title" height="450" width="250"/>

When user clicks `Login to Cloud` button, from code level [`login()` function](https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/lib/utils/auth.dart#L28) gets called. Inside that function, it calls `appAuth.authorize()` method to popup web browser with WSO2 Cloud's Key manager `/authorize` URL. In this call AppAuth internally generates **code challenge** and sends `code_challenge` and `code_challenger_algorithm` with the request since we use `authorization code grant with PKCE` flow. Apart from that, `client-id`, `redirect URI`, `scope`, `grant_type`, etc are sent as query parameters in the opened URL.

```dart
    final AuthorizationServiceConfiguration serviceConfiguration =
        AuthorizationServiceConfiguration('https://$authDomain/authorize',
            'https://$authDomain/token?tenantDomain=$TENANT_DOMAIN');

    final AuthorizationResponse authorizationResponse =
        await flutterAppAuth.authorize(
      AuthorizationRequest(clientId, redirectUri,
          issuer: 'https://$authDomain',
          scopes: <String>['openid', 'profile', 'offline_access'],
          serviceConfiguration: serviceConfiguration),
    );
```

Then key manager will redirect the web browser to login page. Next user gets following UIs to enter login details and give consent:

<img src="https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/resources/images/browserLogin1.jpeg" alt="Your image title" height="450" width="250"/> | <img src="https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/resources/images/browserLogin2.jpeg" alt="Your image title" height="450" width="250"/>

 Once login details are entered, WSO2 key manager validates them and redirects back to the pre-configured [redirect URI](https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/lib/utils/constants.dart#L26) with **auth code** if validation successful. This `redirectURI` should match with the `redirectURI` we configure in the API store's application.
 
 Next from code level it invokes `/token` endpoint to get tokens with the received **auth code** and **code verifier** which is generated by `flutter_appauth` underneath (we receive `code verifier` back in the response from the previous call. Therefore we passes `authorizationResponse.codeVerifier` to the `/token` request) since it's required in PKCE flow for security validation. `/token` request is made by the following code snippet:
 
 ```dart
     final TokenResponse tokenResponse = await flutterAppAuth.token(TokenRequest(
        clientId, redirectUri,
        serviceConfiguration: serviceConfiguration,
        authorizationCode: authorizationResponse.authorizationCode,
        codeVerifier: authorizationResponse.codeVerifier));
 ```

With a successful response we receive **refresh_token, access_token and id_token**. Flutter has a library called [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage) to securely persist data locally. Therefore once we receive tokens, we add them to secure storage (we can read those values from secure storage when it's needed) as follows:
 
 ```dart
    await secureStorage.write(
        key: 'refresh_token', value: tokenResponse.refreshToken);
    await secureStorage.write(
        key: 'access_token', value: tokenResponse.accessToken);
    await secureStorage.write(key: 'id_token', value: tokenResponse.idToken);
 ```

 - ### API invocation with a valid access token

<img src="https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/resources/images/DiagramApiInvocation200.jpg" alt="Your image title" height="300" width="900"/>

Once login and token generation flow is successful, user is navigated to the 'home' page where user can enter a capital of a country and search country details. 

<img src="https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/resources/images/home.jpeg" alt="Your image title" height="450" width="250"/>

As an example we enter 'colombo' and clicks the 'search' icon in the right side of the search box.Then from code level [invokeApiAction()](https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/lib/home.dart#L109) function gets called. Inside that we send a GET request to the pre-configured [API context URL](https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/lib/utils/constants.dart#L35) with the received access token as shown in the code snippet below:

```dart
    final String url = '$API_CONTEXT_PATH$capital';
    http.Response response = await http.get(
      url,
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        HttpHeaders.contentTypeHeader: ContentType.json.mimeType
      },
    );
```
In a happy path when we are sending this GET request to API Cloud gateway with a valid access token, gateway validates the access token and calls the backend to invoke backend API. If it gets successful, then sends us the JSON response with status code 200. Successful response after mapping to 'Country' objects is visible in the UI as follows:

<img src="https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/resources/images/search1.jpeg" alt="Your image title" height="450" width="250"/> | <img src="https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/resources/images/search2.jpeg" alt="Your image title" height="450" width="250"/>

- ### API invocation with an invalid access token (refreshing access token)

<img src="https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/resources/images/DiagramApiInvocation401.jpg" alt="Your image title" height="380" width="1000"/>

Access tokens are getting expired after a defined period of time (by default it's 3600s). At that kind of a situation, when user searches a capital of a country, from application level it sends the GET request to API Cloud gateway with an invalid access token. At this point, as shown in the diagram token validation gets failed and response comes with a error message and **401 status code**.

When application receives 401 response, from code level it calls to [refreshAccessToken()](https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/lib/utils/auth.dart#L76) function to refresh access token using [refresh token grant](https://docs.wso2.com/display/APICloud/Refresh+Token+Grant). Then again sends the GET request with the newly received valid access token to API Cloud gateway as shown in the below snippet:

```dart
    if (response.statusCode == 401) {
      final String accessToken = await refreshAccessToken(
          clientId: AUTH_CLIENT_ID,
          redirectUri: AUTH_REDIRECT_URI,
          issuer: AUTH_ISSUER,
          domain: AUTH_DOMAIN);

      response = await http.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
          HttpHeaders.contentTypeHeader: ContentType.json.mimeType
        },
      );
    }
```

With that user gets the expected successful results in the home page. Checking the status code for 200 and 401 runs underneath from code level so that refreshing access token and resending the GET request if we receive 401 from first request is not visible to enduser. As a practice we recommend only to refresh token if it's expired/invalid. Unless regenerating a token for every call is very costly.

- ### Logout

<img src="https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/resources/images/DiagramLogout.jpg" alt="Your image title" height="200" width="500"/>

If user wants to logout from the application, s/he needs to click 'power' icon in the tab bar right side corner. Then it will pop up a confirmation message as follows:

<img src="https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/resources/images/logoutConfrmation.jpeg" alt="Your image title" height="450" width="250"/>

If user clicks 'Yes', then from code level it calls [logoutAction()](https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/lib/main.dart#L160). Then it will deletd the 'refresh token' from secure storage and mark the user as false as below:

```dart
  Future<void> logoutAction() async {
    await secureStorage.delete(key: 'refresh_token');
    setState(() {
      isLoggedIn = false;
      isBusy = false;
    });
  }
```

Once logged out, user is navigated to the initial 'Login' page of the application.

## What's Next

This sample mobile app can be improved further to cater your business requirements. Here we have few more suggestions to start with:

 - Handle exceptions, error codes and error messages in a more informative way.
 - Implement exponential backoff strategy 
 
