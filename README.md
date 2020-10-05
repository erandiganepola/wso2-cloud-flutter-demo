# Securely consuming WSO2 API Cloud APIs with Flutter

## Introduction

With mobile revolution, businesses tend to provide their products and services via mobile applications apart from the conventional web applications. Mobile applications provide faster access, portability, frequent customer engagement and many more as advantages.

When developing mobile applications, technology stack, security and usability are the main concerns. The “write once, run anywhere” approach that comes with cross platform  applications allows developers to utilize a single code on multiple platforms, which greatly reduces costs and shortens the development time , unlike native apps.

When invoking APIs securely, shipping credentials/access tokens (ex: client-secrets) with the application is not recommended because they can be easily exposed. The proposed approach is using [authorization code grant type](https://is.docs.wso2.com/en/latest/learn/authorization-code-grant/) which authenticates with an authorization server using a combination of client-id and authorization code. But then again authorization code can be intercepted. Therefore the recommended way for mobile applications is [authorization code grant with proof key for code exchange](https://is.docs.wso2.com/en/5.9.0/learn/try-authorization-code-grant/). Refer the [spec](https://tools.ietf.org/html/rfc7636) for PKCE for public clients.

In this project, we have written a [Flutter](https://flutter.dev/) mobile application which securely invokes an API through WSO2 API Cloud using authorization code grant type with PKCE .

## Problem

We need to write a novel cross platform (iOS/Android) mobile application which uses single sign on (SSO) and securely invokes an existing API to reach a wider audience while providing them ease of access. Implementing recommended security standards like authorization code with PKCE ourselves is time consuming. 

## Solution

### Choosing recommended security standards
When developing SSO mobile applications securely, authorization code grant with PKCE flow is recommended to mitigate the effects of authorization code interception attacks. Therefore PKCE will make authorization flow more secure by providing a way to generate a code-verifier and code challenge that are used when requesting the access token so that an attacker who intercepts the authorization code can’t make use of the stolen authorization-code.

### Choosing a cross platform mobile application framework
[Flutter](https://flutter.dev/) and [React Native](https://reactnative.dev) frameworks are the leading contenders while React Native is more matured and Flutter is better in performance with more support for native components. Experts have predicted that Flutter will be the future of mobile app development. Furthermore Flutter has an 'AppAuth' library named ['flutter_appauth'](https://pub.dev/packages/flutter_appauth) which handles the 'auth code with PKCE' flow. Considering those reasons and after comparing both frameworks, we decided to use Flutter to develop this mobile application.

Flutter framework uses Google's [Dart](https://dart.dev) language. It is used to develop for multiple platforms such as mobile, desktop, server, and web applications.

### Implementing security and more
We earlier mentioned that implementing security standards by ourselves is time consuming. Additionally monitoring, throttling and may be API monetization are required to be handled. In summary we need a matured API Management solution. 

When considering the above factors, [WSO2 API Cloud](https://wso2.com/api-management/cloud/) is the most suitable solution. Refer this article for more details - [A Guide to Selecting the Right API Management SaaS](https://wso2.com/blogs/thesource/a-guide-to-selecting-the-right-api-management-saas/)


So in this project we will develop an app which demonstrates how a consumer can write a mobile app to consume APIs securely with WSO2 API Cloud.

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
- Subscribe to previously published API from the newly created application.
- Signin to [WSO2 Keymanager](https://keymanager.api.cloud.wso2.com/carbon/) by giving username as 'youruser@email.com@tenant' and give your password. Then enable [Allow "Authentication without client secret" configuration under the OIDC service provider config](https://is.docs.wso2.com/en/latest/learn/configuring-oauth2-openid-connect-single-sign-on/).
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
 
