# Images Gallery App

![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)
![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)
![CocoaPods](https://img.shields.io/cocoapods/v/SnapKit.svg)

## Images Gallery App Screenshots

<img src="https://github.com/matsa007/ImagesGallery/blob/main/readme_screenshots/1.png" width="187.5" height="406" alt="Image"> <img src="https://github.com/matsa007/ImagesGallery/blob/main/readme_screenshots/2.png" width="187.5" height="406" alt="Image"> <img src="https://github.com/matsa007/ImagesGallery/blob/main/readme_screenshots/3.png" width="187.5" height="406" alt="Image"> <img src="https://github.com/matsa007/ImagesGallery/blob/main/readme_screenshots/4.png" width="187.5" height="406" alt="Image"> <img src="https://github.com/matsa007/ImagesGallery/blob/main/readme_screenshots/5.png" width="187.5" height="406" alt="Image">


## Project Overview

## My telegram: @serhio_honzales

A simple image gallery app that allows users to browse and favourite images fetched from an API. You can add and delete favourite images.

Used:
- MVVM
- SnapKit
- Combine
- Async / Await
- UserDefaults

## Features

- Mark images as favourite
- Delete favourite images
- Saving

## Requirements

- iOS 13.0+
- Xcode 12.0+


## Installation

1. Clone repository:
```
$ git clone https://github.com/matsa007/ImagesGallery.git
cd ImagesGallery
```
2. CocoaPods is a dependency manager for Cocoa projects. You can install it with the following command:
```
$ sudo gem install cocoapods

```
3. To integrate SnapKit into your Xcode project using CocoaPods, specify it in your `Podfile`:
```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'SnapKit', '~> 5.6.0'
end
```
Then, run the following command:
```
$ pod install
```
4. Open `ImagesGallery.xcworkspace` file in Xcode:
```
$ open ImagesGallery.xcworkspace
```
5. Select the target device or simulator from the top-left dropdown menu.

6. Click the "Run" button or use the shortcut `Cmd + R` to build and run.

## Using SnapKit

This application utilizes SnapKit for a more convenient and declarative approach to creating layout constraints for the interface. For example, to add a view with automatic constraint creation, use the following code:
```
import SnapKit

let myView = UIView()
self.view.addSubview(myView)

myView.snp.makeConstraints { make in
    make.top.equalToSuperview().offset(20)
    make.left.equalToSuperview().offset(16)
    make.right.equalToSuperview().offset(-16)
    make.height.equalTo(50)
}
```
With SnapKit, you can define constraints easily and efficiently, making your UI layout code cleaner and more maintainable.
