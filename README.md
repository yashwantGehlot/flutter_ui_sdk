# Finvu Flutter Mobile SDK Integration Guide

## Introduction
Welcome to the integration guide for Finvu Flutter SDK! This document provides detailed instructions on integrating our SDK into your flutter application.

## Prerequisites
1. Flutter
    1. Dart SDK version supported is >=3.3.0 <4.0.0
    2. Flutter version supported is >=3.3.0
2. Android
    1. Min SDK version supported is 24
    2. Min kotlin version supported is 1.9.0
3. iOS
    1. Min iOS version supported is iOS 13

## Installation
1. Add `finvu_flutter_sdk` and `finvu_flutter_sdk_core` dependencies in your `pubspec.yaml`
```
dependencies:
  flutter:
    sdk: flutter
  finvu_flutter_sdk:
    git:
      url: https://github.com/Cookiejar-technologies/finvu_ios_sdk.git
      path: client
      ref: 1.0.0
  finvu_flutter_sdk_core:
    git:
      url: https://github.com/Cookiejar-technologies/finvu_ios_sdk.git
      path: core
      ref: 1.0.0
```
2. On android add the following repository to your project level `build.gradle` file. Note that you need to provide some github credentials.
```
allprojects {
    repositories {
        google()
        mavenCentral()
        
        // Add these lines
        maven { 
            url 'https://maven.pkg.github.com/Cookiejar-technologies/finvu_flutter_sdk' 
            credentials {
                username = System.getenv("GITHUB_PACKAGE_USERNAME")
                password = System.getenv("GITHUB_PACKAGE_TOKEN")
            }
        }
    }
}
```
3. On iOS add the following to your `Podfile`
```
target 'Runner' do
  use_frameworks!
  use_modular_headers!

  ## Add this line
  pod 'FinvuSDK' , :git => 'https://github.com/Cookiejar-technologies/finvu_ios_sdk.git'

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
end

```

## Initialization
TODO

## Usage
TODO

## Frequently Asked Questions
TODO
