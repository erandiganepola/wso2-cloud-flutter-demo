# Get Started with Flutter Authentication

[Flutter](https://flutter.dev/) is Google's cross-platform UI toolkit created to help developers build expressive and beautiful mobile applications. In the article, you will learn how to build and secure a Flutter application with WSO2 API Cloud. This app demonstrates how a consumer can write a mobile app to consume WSO2 API Cloud APIs. Mainly about how to get a token, invoke an API, login, logout of application etc.

## What You'll Build


## Project Setup

- Clone project.

- Install dependencies by clicking "Pub get" in your IDE or run the following command in the project root:

```bash
flutter pub get
```

## Prerequisites to setup in Cloud
- Create an API by setting endpoint to "https://restcountries.eu/#api-endpoints-capital-city"
- Create an application by visiting API Cloud Store by enabling code grant with redirect URL
- Subscribe to that API from the created applicaion
- Signin to WSO2 Keymanager and enable `Allow Authentication without client secret` configuration under the OIDC service provider config
- Set relevant values in cloned project's 'constants.dart' file

## Run the Application

 - Enabled developer options and USB Debugging in mobile phone’s settings OR launch either the [iOS simulator](https://flutter.dev/docs/get-started/install/macos#set-up-the-ios-simulator) or [Android emulators](https://flutter.dev/docs/get-started/install/macos#set-up-the-android-emulator), then run the application on all available devices from your IDE or using following command:

```bash
flutter run -d all
```
