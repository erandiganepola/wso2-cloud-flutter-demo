# Securely consuming WSO2 API Cloud APIs with Flutter

## Use Case

Mobile revolution has ushered in a new era for business since it gives many advantages to business such as adding value to customers, increasing customer engagement and increasing brand recognition, etc. So that, you will be urged to consume APIs via mobile applications. But when it comes to imeplementing mobile applications, there are security, userbility and other concerns you need to address. 

Public clients, such as applications running in a browser or on a mobile device are unable to use registered client secrets. Because they can't keep client-secrets safe. So storing the client-secret in a public client(SPA or mobile app) is not recommended. Therefore, they have to authenticate with the authorization server only using client-id.  But then again authorization code is exposed in the network calls.

Moreover, developing native applications doesn't make sence nowadays. The “write once, run anywhere” approach that comes with cross platform  applications allows developers to utilize a single code on multiple platforms, which greatly reduces costs and shortens the development time , unlike native apps.

## Solution

Mobile applications can be introduced as another sales channel which increases customer engagement and adds more value to business. 

When implementing your mobile application securely, since public clients do not need client-secret, it is recommended to use authorization code grant with PKCE for public-clients. Refer the [spec](https://tools.ietf.org/html/rfc7636) for PKCE for public clients. A proof of possession mechanism has been introduced to mitigate the effects of authorization code interception attacks. So PKCE will make authorization flow more secure. It provides a way to generate a code-verifier that is used when requesting the access token so that an attacker who intercepts the authorization code can’t make use of the stolen authorization-code.

When it comes to building cross platform mobile applications which can be built to run in Android and iOS both, Flutter freamework is in hype and it is well matured by now. [Flutter](https://flutter.dev/) is Google's cross-platform UI toolkit created to help developers build expressive and beautiful mobile applications. [Dart](https://dart.dev) is a client-optimized Google's programming language for apps on multiple platforms. It is used to build mobile, desktop, server, and web applications.

So in this project, you will learn how to build and secure a simple Flutter mobile application from Dart language. This app demonstrates how a consumer can write a mobile app to consume WSO2 API Cloud APIs securely. Mainly about how to implement login, logout and API invokation flows.

## Implementation

You will build a mobile app with following UIs:

- Login UIs

| <img src="https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/resources/images/login.jpeg" alt="Your image title" height="450" width="250"/> | <img src="https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/resources/images/browserLogin1.jpeg" alt="Your image title" height="450" width="250"/> | <img src="https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/resources/images/browserLogin2.jpeg" alt="Your image title" height="450" width="250"/> |

- Home / Search UIs

| <img src="https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/resources/images/home.jpeg" alt="Your image title" height="450" width="250"/>
| <img src="https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/resources/images/search1.jpeg" alt="Your image title" height="450" width="250"/> | <img src="https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/resources/images/search2.jpeg" alt="Your image title" height="450" width="250"/>

- Logout UI
<img src="https://github.com/erandiganepola/wso2-cloud-flutter-demo/blob/master/resources/images/logoutConfrmation.jpeg" alt="Your image title" height="450" width="250"/>

### Setup your Development Environment
Development Environment, one of:
- [Android Studio](https://developer.android.com/studio), or
- [IntelliJ IDEA](https://www.jetbrains.com/idea/download/#section=linux), or
- [Visual Studio Code](https://code.visualstudio.com/download)

These IDEs integrate well with Flutter. You will need an installation of the Dart and Flutter plugins, regardless of the IDE you decide to use.

Next download and install Flutter [SDK](https://flutter.dev/docs/get-started/install) and set path in your '.bashrc' file and source it.

### Project Setup

- Clone project.

- In this project you will use three main dependencies. Those are 'http', 'flutter_appauth' and 'flutter_secure_storage'. Refer [official documentation](https://auth0.com/blog/get-started-with-flutter-authentication/#Install-Dependencies) for more information on these dependencies.

- Install dependencies by clicking "Pub get" in your IDE or run the following command in the project root:

```bash
flutter pub get
```

### Prerequisites to setup in Cloud
- Create an account in WSO2 Cloud if you don't have one and login to [Publisher portal](https://api.cloud.wso2.com/publisher).
- [Create an API](https://docs.wso2.com/display/APICloud/Create+and+Publish+an+API). When creating your API, add a "GET" method for the resource path "/capital/{capital}" and set the endpoint URL to "https://restcountries.eu/rest/v2". At the end your API should call [REST Countries Capital City endpoint](https://restcountries.eu/#api-endpoints-capital-city). Then publish your API.
- Visit WSO2 API Store and [create an application](https://docs.wso2.com/display/APICloud/Subscribe+to+and+Invoke+an+API). Enable code grant with a redirect URL (ex: org.wso2.cloud.flutterdemo://login-callback) and generate tokens.
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
const String AUTH_REDIRECT_URI = 'org.wso2.cloud.flutterdemo://login-callback';

// Auth token issuer domain
const String AUTH_ISSUER = 'https://$AUTH_DOMAIN';

// Your tenant domain
const String TENANT_DOMAIN = 'vlgunarathne';

// Full API context path (apart from URL param attached)
const String API_CONTEXT_PATH =
    'https://$AUTH_DOMAIN/t/$TENANT_DOMAIN/demo/v1.0/capital/';

```

### Run the Application

To run the application you have two options. Either to run in your mobile application or to run in a simulator.

 - Option 01 : [Enable developer options and USB Debugging](https://www.howtogeek.com/129728/how-to-access-the-developer-options-menu-and-enable-usb-debugging-on-android-4.2/#:~:text=To%20enable%20Developer%20Options%2C%20open,times%20to%20enable%20Developer%20Options.) in mobile phone’s settings and run the application.
 - Option 02 : Launch either the [iOS simulator](https://flutter.dev/docs/get-started/install/macos#set-up-the-ios-simulator) or [Android emulators](https://flutter.dev/docs/get-started/install/macos#set-up-the-android-emulator), then run the application. 
 - You can run the application from your IDE or using following command:

```bash
flutter run -d all
```
### Login, Invoke API and Logout

After running the application, UI will be popped out with a button to 'Login to WSO2 Cloud'. Once you click it, you will be navigated to WSO2 authorization login page. There you need to enter username as 'youruser@email.com@tenant' and give your password. Then approve access to your user profile information. When it's successful, you will be directed to Home page. There you can enter a capital of a country and click 'Search'. You will see results in the UI. 

If user needs to sign out, click 'power button' in the top bar right side corner. 

## What's Next

This sample mobile app can be improved further to cater your business requirements. Here we have few more suggestions to start with:

 - Handle exceptions, error codes and error messages in a more informative way.
 - Implement exponential backoff strategy 
 
 

