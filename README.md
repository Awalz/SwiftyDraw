<h1 align="center">SwiftyDraw</h1>

<p align="center">
    <img src="https://img.shields.io/badge/platform-iOS%209%2B-blue.svg?style=flat" alt="Platform: iOS 9.1+"/>
    <a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/language-swift%204-4BC51D.svg?style=flat" alt="Language: Swift 4" /></a>
    <a href="https://cocoapods.org/pods/SwiftyDraw"><img src="https://img.shields.io/cocoapods/v/SwiftyDraw.svg?style=flat" alt="CocoaPods" /></a>
    <img src="http://img.shields.io/badge/license-BSD-lightgrey.svg?style=flat" alt="License: BSD" /> <br><br>
</p>

---

This is an original fork from [Awalz's SwiftyDraw](https://github.com/Awalz/SwiftyDraw) repository.

---

## Overview

SwiftyDraw is a simple, lightweight drawing framework written in Swift. SwiftyDraw is built using Core Gaphics and is very easy to implement.

## Requirements
* iOS 9.1+
* Swift 4

## License

SwiftyDraw is available under the BSD license. See the LICENSE file for more info.

## Installation

### Cocoapods:

SwiftyDraw is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SwiftyDraw'
```

### Manual Installation:

Simply copy the contents of the Source folder into your project.

## Usage

Using SwiftyDraw is very simple:

### Getting Started:

Simply create a SwiftyDrawView and add it to your View Controller:

```swift
let drawView = SwiftyDrawView(frame: self.view.frame)
self.view.addSubview(drawView)
```
    
By default, the view will automatically respond to touch gestures and begin drawing. The default color is **black**.

To disable drawing, simply set the `drawingEnabled` property to false:

```swift
drawView.drawingEnabled = false
```
    
## Customization

### Line Color:

The color of a line stoke can be changed by adjusting the `lineColor` property. SwiftyDraw accepts any UIColor:

```swift
drawView.lineColor = UIColor.red
```
    
<p align="center">
  or
</p>

```swift
drawView.lineColor = UIColor(colorLiteralRed: 0.75, green: 0.50, blue: 0.88, alpha: 1.0)
```    
### Line Width:

The with of a line stroke can be changed by adjusting the `lineWidth` property. SwiftyDraw accepts any positive CGFloat:

```swift
drawView.lineWidth = CGFloat(5.0)
```

### Line Opacity:

The opacity of a line stoke can be changed by adjusting the `lineOpacity` property. SwiftyDraw accepts a CGFloat between 0. and 1.0:

```swift
drawView.lineOpacity = CGFloat(0.5)
```
    
## Editing

### Clear All:

If you wish to clear the entire canvas, simply call the `clear` function:

```swift
drawView.clear()
``` 

### Undo the last change:

```swift
drawView.undo()
``` 

...and redo:

```swift
drawView.redo()
``` 
    
## Delegate

SwiftyDraw has delegate functions to notify you when a user is interacting with a SwiftDrawView. To access these delegate methods, simply add your View Controller as the `SwiftyDrawViewDelegate`:

```swift
class ViewController: UIViewController, SwiftyDrawViewDelegate
```

### There are five delegate methods

```swift
/// SwiftyDrawViewDelegate called when a touch gesture should begin on the SwiftyDrawView using given touch type
func swiftyDraw(shouldBeginDrawingIn drawingView: SwiftyDrawView, using touch: UITouch) -> Bool
    
/// SwiftyDrawViewDelegate called when a touch gesture begins on the SwiftyDrawView.
func swiftyDraw(didBeginDrawingIn drawingView: SwiftyDrawView, using touch: UITouch)

/// SwiftyDrawViewDelegate called when touch gestures continue on the SwiftyDrawView.
func swiftyDraw(isDrawingIn drawingView: SwiftyDrawView, using touch: UITouch)
    
/// SwiftyDrawViewDelegate called when touches gestures finish on the SwiftyDrawView.
swiftyDraw(didFinishDrawingIn drawingView: SwiftyDrawView, using touch: UITouch)
    
/// SwiftyDrawViewDelegate called when there is an issue registering touch gestures on the  SwiftyDrawView.
func swiftyDraw(didCancelDrawingIn drawingView: SwiftyDrawView, using touch: UITouch)
```

 
### Contribution

If you would like to propose any enhancements, bug fixes, etc., feel free to create a pull request or an issue respectively.

### Contact

If you have any questions, or just want to say hi, reach out to me via [Twitter](https://twitter.com/linusgeffarth), or [email](mailto:linus@geffarth.de).
