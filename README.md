![Blurry](https://github.com/piemonte/Blurry/blob/master/Blurry.png)

## Blurry 🌫

Image blurring in [Swift](https://developer.apple.com/swift/).

[![Build Status](https://travis-ci.org/piemonte/Blurry.svg?branch=master)](https://travis-ci.org/piemonte/Blurry) [![Pod Version](https://img.shields.io/cocoapods/v/Blurry.svg?style=flat)](http://cocoadocs.org/docsets/Blurry/) [![Swift Version](https://img.shields.io/badge/language-swift%204.2-brightgreen.svg)](https://developer.apple.com/swift) [![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://github.com/piemonte/Blurry/blob/master/LICENSE)

This library is a small CoreImage wrapper that performs a variety of blurring techniques based on the given parameters.

Need a different version of Swift?
* `4.2` - Target your Podfile to the `swift4.2` branch
* `4.0` - Target your Podfile to the latest release or master

## Quick Start

`Blurry` is available and recommended for installation using the Cocoa dependency manager [CocoaPods](http://cocoapods.org/). You can also simply copy the `Blurry.swift` file into your Xcode project.

## Installation

```ruby
# CocoaPods
swift_version = "4.2"
pod "Blurry", "~> 0.1.0"

# Carthage
github "piemonte/Blurry" ~> 0.1.0

# SwiftPM
let package = Package(
    dependencies: [
        .Package(url: "https://github.com/piemonte/Blurry", majorVersion: 0)
    ]
)
```

## Usage

``` Swift
import Blurry
```

```swift
// using UIImage extension, an example with a few parameters
let blurryImage = originalImage.blurryImage(blurRadius: 12.0)

// or if you prefer no extension, an example with more parameters
let blurryImage = Blurry.blurryImage(withOptions: BlurryOptions.pro, overlayColor: overlayColor, forImage: sampleImage, size: sampleImage.size, blurRadius: 12.0)

```

## License

Blurry is available under the MIT license, see the [LICENSE](https://github.com/piemonte/blurry/blob/master/LICENSE) file for more information.
