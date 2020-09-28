# Get Started with Flutter Authentication

[Flutter](https://flutter.dev/) is Google's cross-platform UI toolkit created to help developers build expressive and beautiful mobile applications. [Dart](https://dart.dev) is a client-optimized Google's programming language for apps on multiple platforms. It is used to build mobile, desktop, server, and web applications. 

In this project, you will learn how to build and secure a simple Flutter mobile application from Dart language. This app demonstrates how a consumer can write a mobile app to consume WSO2 API Cloud APIs securely. Mainly about how to implement login, logout and API invokation flows.

## What You'll Build


## Project Setup

- Clone project.

- Install dependencies by clicking "Pub get" in your IDE or run the following command in the project root:

```bash
flutter pub get
```

## Prerequisites to setup in Cloud
- Create an account in WSO2 Cloud if you don't have one and login to [Publisher portal](https://api.cloud.wso2.com/publisher).
- [Create an API](https://docs.wso2.com/display/APICloud/Create+and+Publish+an+API). When creating your API, add a "GET" method for the resource path "/capital/{capital}" and set the endpoint URL to "https://restcountries.eu/rest/v2". At the end your API should call [REST Countries Capital City endpoint](https://restcountries.eu/#api-endpoints-capital-city). Then publish your API.
- Visit WSO2 API Store and [create an application](https://docs.wso2.com/display/APICloud/Subscribe+to+and+Invoke+an+API). Enable code grant with a redirect URL (ex: com.auth0.flutterdemo://login-callback) and generate tokens.
- Subscribe to previously published API from the newly created applicaion.
- Signin to [WSO2 Keymanager](https://keymanager.api.cloud.wso2.com/carbon/) by giving username as 'youruser@email.com@tenant' and give yor password. Then enable [Allow "Authentication without client secret" configuration under the OIDC service provider config](https://is.docs.wso2.com/en/latest/learn/configuring-oauth2-openid-connect-single-sign-on/).
- Set relevant values in cloned project's 'lib/utils/constants.dart' file. Sample is given below:
```
/// -----------------------------------
///          Global Constants
/// -----------------------------------

// WSO2 API Cloud URL domain
const String AUTH_DOMAIN = 'gateway.api.cloud.wso2.com';

// Your client ID obtained by creating an application in WSO2 Store
const String AUTH_CLIENT_ID = 'fO0rk7lzuWZKxxxxxxixxxxx';

// Call back URL specified in your application
const String AUTH_REDIRECT_URI = 'com.auth0.flutterdemo://login-callback';

// Auth token issuer domain
const String AUTH_ISSUER = 'https://$AUTH_DOMAIN';

// Full API context path (apart from URL param attached)
const String API_CONTEXT_PATH =
    'https://gateway.api.cloud.wso2.com/t/vlgunarathne/demo/v1.0/capital/';

```

## Run the Application

To run the application you have two options. Either to run in your mobile application or to run in a simulator.

 - Option 01 : [Enable developer options and USB Debugging](https://www.howtogeek.com/129728/how-to-access-the-developer-options-menu-and-enable-usb-debugging-on-android-4.2/#:~:text=To%20enable%20Developer%20Options%2C%20open,times%20to%20enable%20Developer%20Options.) in mobile phone’s settings and run the application.
 - Option 02 : Launch either the [iOS simulator](https://flutter.dev/docs/get-started/install/macos#set-up-the-ios-simulator) or [Android emulators](https://flutter.dev/docs/get-started/install/macos#set-up-the-android-emulator), then run the application. 
 - You can run the application from your IDE or using following command:

```bash
flutter run -d all
```
## Login and Invoke API

After running the application, UI will be popped out with a button to 'Login to WSO2 Cloud'. Once you click it, you will be navigated to WSO2 authorization login page. There you need to enter username as 'youruser@email.com@tenant' and give your password. Then approve access to your user profile information. When it's successful, you will be directed to Home page. There you can enter a capital of a country and click 'Search'. You will see results in the UI. If user needs to sign out, click 'power button' in the top bar right side corner. 
