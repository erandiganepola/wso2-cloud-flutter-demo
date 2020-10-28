# Securely Consume your WSO2 Cloud APIs using Flutter Mobile App

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
  - [Login, Invoke API, Change Settings and Logout](https://github.com/erandiganepola/wso2-cloud-flutter-demo#login-invoke-api-change-settings-and-logout)
- [Implementation](https://github.com/erandiganepola/wso2-cloud-flutter-demo#implementation)
  - [Login and token generation](https://github.com/erandiganepola/wso2-cloud-flutter-demo#login-and-token-generation)
  - [API invocation with a valid access token](https://github.com/erandiganepola/wso2-cloud-flutter-demo#api-invocation-with-a-valid-access-token)
  - [API invocation with an invalid access token (refreshing access token)](https://github.com/erandiganepola/wso2-cloud-flutter-demo#api-invocation-with-an-invalid-access-token-refreshing-access-token)
  - [Change settings (tenant domain and client ID)](https://github.com/erandiganepola/wso2-cloud-flutter-demo#change-settings-tenant-domain-and-client-id)
  - [Logout](https://github.com/erandiganepola/wso2-cloud-flutter-demo#logout)
- [What's Next](https://github.com/erandiganepola/wso2-cloud-flutter-demo#whats-next)

## Introduction

With mobile revolution, businesses tend to provide their products and services via mobile applications apart from the conventional web applications. Mobile applications provide faster access, portability, frequent customer engagement and many more as advantages.

When developing mobile applications, technology stack, security and usability are the main concerns. The _“write once, run anywhere”_ approach that comes with cross platform  applications allows developers to utilize a single code on multiple platforms, which greatly reduces costs and shortens the development time , unlike native apps.

When invoking APIs securely, embed the credentials/access tokens (ex: client-secrets) in app distributions is not recommended because they can be easily exposed. The proposed approach is using [authorization code grant type](https://is.docs.wso2.com/en/latest/learn/authorization-code-grant/) which authenticates with an authorization server using a combination of client-id and authorization code. But then again authorization code can be intercepted. 

Unlike [confidential clients](https://oauth.net/2/client-types/), [public clients](https://oauth.net/2/client-types/) are unable to keep registered client secret safe, such as applications running in a browser or on a mobile device.
Therefore the recommended way for mobile applications is ['authorization code grant with proof key for code exchange'](https://is.docs.wso2.com/en/5.9.0/learn/try-authorization-code-grant/). Refer the [RFC-7636 spec](https://tools.ietf.org/html/rfc7636) on Proof Key for Code Exchange (PKCE) by OAuth Public Clients for more details.

In this project, we have written a [Flutter](https://flutter.dev/) mobile application which securely invokes an API through [WSO2 API Cloud](https://wso2.com/api-management/cloud/) using `authorization code grant with PKCE` .

## Problem

Companies build mobile apps on both iOS and Android and thus it helps businesses to target customers across the world. But developing specific native apps increases cost and consumes time.Therefore we need to write a novel cross platform (iOS/Android) mobile application which uses single sign on (SSO) and securely invokes an existing API to reach a wider audience while providing them ease of access. Implementing recommended security standards like `authorization code grant with PKCE` ourselves is time consuming. 

## Solution

- ### Choosing recommended security standards
As discussed in the introduction, when developing SSO mobile applications securely, `authorization code grant with PKCE` flow is recommended to mitigate the effects of authorization code interception attacks. Therefore PKCE will make authorization flow more secure by providing a way to generate a `code-verifier` and `code challenge` that are used when requesting the access token so that an attacker who intercepts the authorization code can’t make use of the stolen authorization-code.

- ### Choosing a cross platform mobile application framework
[Flutter](https://flutter.dev/) and [React Native](https://reactnative.dev) frameworks are the leading contenders while React Native is more matured and Flutter is better in performance with more support for native components. Experts have predicted that Flutter will be the future of mobile application development. Furthermore Flutter has an 'AppAuth' library named ['flutter_appauth'](https://pub.dev/packages/flutter_appauth) which handles the 'authorization code with PKCE' flow. Considering those reasons and after comparing both frameworks, we decided to use Flutter to develop this mobile application. Please refer this article for more details on [Flutter vs React Native vs Native Comparison](https://medium.com/swlh/flutter-vs-react-native-vs-native-deep-performance-comparison-990b90c11433).

Flutter framework uses Google's [Dart](https://dart.dev) language. It is used to develop for multiple platforms such as mobile, desktop, server, and web applications.

- ### Implementing security and more
We earlier mentioned that implementing security standards by ourselves is time consuming. Additionally monitoring, throttling and many more are required to be handled. In summary we need a matured API Management solution. 

When considering the above factors, [WSO2 API Cloud](https://wso2.com/api-management/cloud/) is the most suitable solution. Refer this article for more details on selecting the right API Management solution - [A Guide to Selecting the Right API Management SaaS](https://wso2.com/blogs/thesource/a-guide-to-selecting-the-right-api-management-saas/).


Therefore in this project we will develop an application which demonstrates how a consumer can write a mobile application to consume APIs securely with WSO2 API Cloud.

## Setup your Environment
Development Environment, one of:
- [Android Studio](https://developer.android.com/studio), or
- [IntelliJ IDEA](https://www.jetbrains.com/idea/download/#section=linux), or
- [Visual Studio Code](https://code.visualstudio.com/download)

These IDEs integrate well with Flutter. You will need an installation of the Dart and Flutter plugins, regardless of the IDE you decide to use.

Next download and install Flutter [SDK](https://flutter.dev/docs/get-started/install) and set path in your `.bashrc` file and source it.

- ### Project Setup

  - Clone project - `git clone https://github.com/erandiganepola/wso2-cloud-flutter-demo.git`

  - In this project you will use three main dependencies. Those are `http`, `flutter_appauth` and `flutter_secure_storage`. Refer [official documentation](https://auth0.com/blog/get-started-with-flutter-authentication/#Install-Dependencies) for more information on these dependencies.

  - Install dependencies by clicking `Pub get` in your IDE or run the following command in the project root:

```bash
flutter pub get
```

- ### Prerequisites to setup in WSO2 Cloud
  - Create an account in WSO2 Cloud if you don't have one already and login to [Publisher portal](https://api.cloud.wso2.com/publisher).
  
  - [Create an API using an existing swagger definition](https://cloud.docs.wso2.com/en/latest/learn/design-apis/design-api-using-existing-swagger/). You can find the relevant swagger in [swagger.yaml](https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/swagger.yaml) file. When creating your API, set context as `/demo` and set the production, sandbox backend endpoints to `https://restcountries.eu/rest/v2`. Also select `Subscription Tiers` in `Manage` tab as necessary (I have set to `Unlimited` in my API). Then publish your API. At the end of this demo your API will be calling [REST Countries Capital City endpoint](https://restcountries.eu/#api-endpoints-capital-city) as the backend.
  
  - Visit WSO2 API Store and [create an application](https://docs.wso2.com/display/APICloud/Subscribe+to+and+Invoke+an+API). Enable (put a tick for the `Code` grant box) code grant with the callback URI. We have set callback URI to `org.wso2.cloud.flutterdemo://login-callback` in this sample. Then generate keys.
  
  - Subscribe to previously published API from the newly created application.
  
  - You need to enable ["Allow authentication without client secret configuration" under the OIDC service provider config](https://is.docs.wso2.com/en/latest/learn/configuring-oauth2-openid-connect-single-sign-on/) in WSO2 API Cloud to use `Authorization code grant type with PKCE` **without client secret**. For that please send an email to `cloud@wso2.com` to configure it for your application. 
  
  - Set relevant values as your `AUTH_CLIENT_ID` and `TENANT_DOMAIN` in cloned project's `lib/utils/constants.dart` file. Sample is given below:
  
```dart
/// Global Constants

// WSO2 API Cloud URL domain
const String AUTH_DOMAIN = 'gateway.api.cloud.wso2.com';

// Your client ID obtained by creating an application in WSO2 Store
const String AUTH_CLIENT_ID = 'fO0rk7lzuWZKRofN13zxxxxxxx';

// Call back URL specified in your application
const String AUTH_REDIRECT_URI = 'org.wso2.cloud.flutterdemo://login-callback';

// Auth token issuer domain
const String AUTH_ISSUER = 'https://$AUTH_DOMAIN';

// Your tenant domain
const String TENANT_DOMAIN = 'erandiorg';
```

- ### Run the Application

To run the application you have two options. Either to run in your mobile application or to run in a simulator.

  - Option 01 : [Enable developer options and USB Debugging](https://www.howtogeek.com/129728/how-to-access-the-developer-options-menu-and-enable-usb-debugging-on-android-4.2/#:~:text=To%20enable%20Developer%20Options%2C%20open,times%20to%20enable%20Developer%20Options.) in mobile phone’s settings and run the application after connecting your mobile phone to your development environment.
  - Option 02 : Launch either the [iOS simulator](https://flutter.dev/docs/get-started/install/macos#set-up-the-ios-simulator) or [Android emulators](https://flutter.dev/docs/get-started/install/macos#set-up-the-android-emulator), then run the application. 
  
  - You can run the application from your IDE or using following command:

```bash
flutter run -d all
```

- ### Login, Invoke API, Change Settings and Logout

After running the application, UI will be popped out with a button named `Login to Cloud`. 

<img src="https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/resources/images/login.jpeg" alt="Your image title" width="250"/>

Once user clicks it, s/he will be navigated to WSO2 authorization login page. There user needs to enter username as `youruser@email.com@tenantdomain` and give password. Then approve access to user profile information. 

<img src="https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/resources/images/browserLogin1.jpeg" alt="Your image title" width="250"/> | <img src="https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/resources/images/browserLogin2.jpeg" alt="Your image title" width="250"/>

When it's successful, user will be navigated to Home page. In the Home page you can enter a capital of a country and click `search icon` in the right side of the search box. You will see results in the UI. 

<img src="https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/resources/images/home.jpeg" alt="Your image title" width="250"/> | 
<img src="https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/resources/images/search1.jpeg" alt="Your image title" width="250"/>

If you need to try out the sample for different tenant domains and different client applications rather than the one you configured in the `constant.dart` file, you can change those configurations by clicking `settings icon` in the top bar. Then a dialog box will be popped up with the existing values for client ID and tenant domain. You can edit them and click `Update` to save.

<img src="https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/resources/images/updateConfigs.jpeg" alt="Your image title" width="250"/>

If user needs to sign out, click `power icon` in the top bar right side corner. Then confirmation box will be popped up. When you click `Yes` it will log out user from the application.

<img src="https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/resources/images/logoutConfrmation.jpeg" alt="Your image title" width="250"/>

## Implementation

To understand the implementation, first let's identify the flow of this scenario. We can divide the complete flow in to following sections.

- Login and token generation
- API invocation with a valid access token
- API invocation with an invalid access token (refreshing access token)
- Change settings (tenant domain and client ID)
- Logout

Now let's go through above sub topics one by one in detail.

- ### Login and token generation

In the following diagram we have shown how login and token generation flows work with `Authorization code grant with PKCE`. 

<img src="https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/resources/images/DiagramLogin_%20tokenGeneration.jpg" alt="Your image title" width="1000"/>

When user opens the mobile application, user is navigated to the `Login` page. For navigations it is recommended to use [Flutter routes](https://flutter.dev/docs/development/ui/navigation) when it comes to Flutter mobile apps. We have used [navigations with named routes](https://flutter.dev/docs/cookbook/navigation/named-routes) in this implementation.

When user opens the application, from code level it starts the app with the [`/login` named initial route](https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/lib/main.dart#L40). Therefore app starts with the [Login widget](https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/lib/login.dart#L23). Inside that Login class it initializes the app and returns app layout with `Login to Cloud` button from [`Widget build(BuildContext context)`](https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/lib/login.dart#L72). 

Once user clicks `Login to Cloud` button, [loginAction()](https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/lib/login.dart#L99) gets called. Inside that function, [login() function initializes](https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/lib/utils/auth.dart#L30) user login and get the access token. Inside login() function `appAuth.authorize()` function pops up web browser with WSO2 Cloud's Key manager `/authorize` URL. In this call `AppAuth` internally generates **code challenge** and sends `code_challenge` and `code_challenger_algorithm` with the request since we use `authorization code grant with PKCE` flow. Apart from that, `client-id`, `redirect URI`, `scope`, `grant_type`, etc are sent as query parameters in the opened URL.

```dart
  final AuthorizationServiceConfiguration serviceConfiguration =
      AuthorizationServiceConfiguration('https://$domain/authorize',
          'https://$domain/token?tenantDomain=$TENANT_DOMAIN');

    final AuthorizationResponse authorizationResponse =
        await flutterAppAuth.authorize(
      AuthorizationRequest(clientId, redirectUri,
          issuer: 'https://$authDomain',
          scopes: <String>['openid', 'profile', 'offline_access'],
          serviceConfiguration: serviceConfiguration),
    );
```

Then key manager will redirect the web browser to login page. Next user gets UIs to enter login details and give consent.

Once login details are entered, WSO2 key manager validates them and redirects back to the pre-configured [redirect URI](https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/lib/utils/constants.dart#L26) with **auth code** if validation successful. This `redirectURI` should match with the `Callback URI` we configured in the API store's application.
 
Next from code level it invokes `/token` endpoint to get tokens with the received **auth code** and **code verifier** which is generated by `flutter_appauth` underneath (we can get the _AppAuth_ generated `codeVerifier` as `authorizationResponse.codeVerifier` and pass it to the `/token` request) since it's required in PKCE flow for security validation. `/token` request is made by the following code snippet:
 
 ```dart
     final TokenResponse tokenResponse = await flutterAppAuth.token(TokenRequest(
        clientId, redirectUri,
        serviceConfiguration: serviceConfiguration,
        authorizationCode: authorizationResponse.authorizationCode,
        codeVerifier: authorizationResponse.codeVerifier));
 ```

With a successful response we receive **refresh_token, access_token and id_token**. Flutter has a library called [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage) to securely persist data locally. Therefore once we receive tokens, we add them to secure storage (we can read those values from secure storage when it's needed). Following code snippet show how to set and get values from secure storage:
 
 ```dart
/// Function to set access token to secure storage
Future<String> setAccessToken(String accessToken) async {
  await secureStorage.write(key: 'access_token', value: accessToken);
}

/// Function to get access token from secure storage
Future<String> getAccessToken() async {
  return secureStorage.read(key: 'access_token');
}
 ```

 - ### API invocation with a valid access token

Following diagram shows how to invoke an already published API using a valid access token (token we retrieved from previous step).

<img src="https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/resources/images/DiagramApiInvocation200.jpg" alt="Your image title" width="900"/>

Once login and token generation flow is successful, user is navigated to the [Home widget](https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/lib/home.dart#L29) where user can enter a capital of a country and search country details. 

As an example we enter 'colombo' and clicks the `search icon` in the right side of the search box. Then from code level [invokeApiAction()](https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/lib/home.dart#L127) function gets called. Inside that we call [fetchCountries()](https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/lib/services/services.dart#L23) function by passing `tenant domain, input value (capital) and access token` to send a GET request to the pre-configured API context URL. fetchCountries() functionality is shown in the code snippet below:

```dart
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
```

In the happy path when we are sending this GET request to API Cloud gateway with a valid access token, WSO2 Cloud's key manager validates the access token and then gateway calls the backend and invoke backend API. If it gets successful, gateway sends us the JSON response with status code 200. Successful responses after mapping to 'Country' objects are visible in the UIs as follows:

<img src="https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/resources/images/search1.jpeg" alt="Your image title" width="250"/> | <img src="https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/resources/images/search2.jpeg" alt="Your image title" width="250"/>

- ### API invocation with an invalid access token (refreshing access token)

Following diagram shows an API invocation with an invalid access token:

<img src="https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/resources/images/DiagramApiInvocation401.jpg" alt="Your image title" width="1000"/>

Access tokens are getting expired after a defined period of time (by default it's 3600s). At that kind of a situation, when user searches a capital of a country, from application level it sends the GET request to API Cloud gateway with an invalid access token. At this point, as shown in the diagram, token validation gets failed and response comes with a error message and **401 status code**.

When application receives 401 response, from code level it calls to [refreshAccessToken()](https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/lib/utils/auth.dart#L75) function to refresh access token using [refresh token grant](https://docs.wso2.com/display/APICloud/Refresh+Token+Grant). Then again sends the GET request with the newly received valid access token to API Cloud gateway as shown in the below snippet:

```dart
    if (response.statusCode == 401) {
      final String accessToken = await refreshAccessToken(
          clientId: await getClientID(),
          redirectUri: AUTH_REDIRECT_URI,
          issuer: AUTH_ISSUER,
          domain: AUTH_DOMAIN);

      // Call fetchCountries() with new access token
      response = await fetchCountries(tenantDomain, capital, accessToken);
    }
```

With that user gets the expected successful results in the home page. Checking the status code for 200 and 401 runs underneath from code level so that refreshing access token and resending the GET request if we receive 401 from first request are not visible to end user. 

As a practice we recommend only to refresh token if it's expired/invalid. Unless regenerating a token for every call is very costly.

- ### Change settings (tenant domain and client ID)

As we discussed in the [Prerequisites to setup in WSO2 Cloud](https://github.com/erandiganepola/wso2-cloud-flutter-demo#prerequisites-to-setup-in-wso2-cloud) section, user needs to update `AUTH_CLIENT_ID` and `TENANT_DOMAIN` in the `lib/utils/constants.dart` file. Therefore those configs will be used as default values for this application. However if user needs to try the same application for different tenants, s/he can change `AUTH_CLIENT_ID` and `TENANT_DOMAIN` from mobile application UI later. We have discussed how to do it in the [Login, Invoke API, Change Settings and Logout](https://github.com/erandiganepola/wso2-cloud-flutter-demo#login-invoke-api-change-settings-and-logout) section.

Once user changes tenant domain and client ID from application dialog box, those values will be saved in the secure storage. Therefore from code level it checks whether these values are available when invoking the API, if not available it will use the default values configured in the `constants.dart` file. This functionality is handled in the [SettingsButton class](https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/lib/home.dart#L282) from code level.

- ### Logout

<img src="https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/resources/images/DiagramLogout.jpg" alt="Your image title" width="500"/>

If user wants to logout from the application, s/he needs to click `power icon` in the tab bar right side corner. Then it will pop up a confirmation dialog. If user clicks `Yes`, then from code level it calls [logoutAction()](https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/lib/home.dart#L186). Then it will delete the `refresh token` from secure storage and will navigate user to `Login widget` as follows:

```dart
  Future<void> logoutAction() async {
    await clearRefreshToken();

    setState(() {
      isBusy = false;
    });

    await Navigator.pushNamedAndRemoveUntil(
        context, '/login', (route) => false);
  }
```

All sub sections we have discussed under [Implementation](https://github.com/erandiganepola/wso2-cloud-flutter-demo#implementation) section cover the overall implementation of the sample application. 

## What's Next

This sample mobile application can be improved further to cater your business use cases. Here we have few more suggestions that you can start with:

 - Keep multiple main files (ex: _main_dev.dart_, _main_prod.dart_) and use `flutter build target` to build for different development environments or release types. You can find more details on how to do it with Flutter in following documentations:
     - [Medium article - Flavors in dart code](https://medium.com/@salvatoregiordanoo/flavoring-flutter-392aaa875f36)
     - [Creating flavors for Flutter - Official documentation](https://flutter.dev/docs/deployment/flavors)
 - Handle exceptions, error codes and error messages in a more informative way.
 - Implement exponential backoff strategy on failed requests. Refer this [example algorithm](https://cloud.google.com/iot/docs/how-tos/exponential-backoff#example_algorithm) for more details on exponential backoff strategy.
 - Users can theme WSO2 authorization login pages matching to their organization's logo and theme. Drop an email to `cloud@wso2.com` if you are interested in trying out this with WSO2 Cloud. Find more details on theming login pages in product documentation from [this link](https://is.docs.wso2.com/en/5.9.0/develop/customizing-login-pages-for-service-providers/). 
 
