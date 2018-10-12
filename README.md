<h1 align="center">SwiftyDraw</h1>

<p align="center">
    <img src="https://img.shields.io/badge/platform-iOS%209%2B-blue.svg?style=flat" alt="Platform: iOS 9.1+"/>
    <a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/language-swift%204-4BC51D.svg?style=flat" alt="Language: Swift 4" /></a>
    <a href="https://cocoapods.org/pods/SwiftyDraw"><img src="https://img.shields.io/cocoapods/v/SwiftyDraw.svg?style=flat" alt="CocoaPods" /></a>
    <img src="http://img.shields.io/badge/license-BSD-lightgrey.svg?style=flat" alt="License: BSD" /> <br><br>
</p>


## Overview

SwiftyDraw is a simple, light-weight drawing framework written in Swift. SwiftyDraw is built using Core Gaphics and is very easy to implement.

## Requirements
* iOS 9.1+
* Swift 4

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

To disable drawing, simply set the `isEnabled` property to false:

```swift
drawView.isEnabled = false
```

## Brushes

For drawing, we use `Brush` to keep track of styles like `width`, `color`, etc.. We have multiple different default brushes, you can use as follows:

```swift
drawView.brush = Brush.default
```

The default brushed are:

```swift
public static var `default`: Brush { get } // black, width 3
public static var thin     : Brush { get } // black, width 2
public static var medium   : Brush { get } // black, width 7
public static var thick    : Brush { get } // black, width 10
public static var marker   : Brush { get } // flat red-ish, width 12
public static var eraser   : Brush { get } // white, width 8; currently this fakes an eraser by using the canvas' background color to draw
```

### Adjusted Width Factor

`SwiftyDrawView` supports drawing-angle-adjusted brushes. Effectively, that means, if the user (using an Pencil) draws with the tip of the pencil, the brush will reduce its width a little. If the user draws at a very low angle, with the side of the pencil, the brush will be a little thicker.
You can modify this behavior by setting `adjustedWidthFactor` of a brush. If you increase the number (to, say, `5`) the changes will increase. If you reduce the number to `0`, the width will not be adjusted at all.
The default value is `1` which causes a slight increase in width.

This is an opt-in feature. That means, in `shouldBeginDrawingIn`, you need to manually put `drawingView.brush.adjustWidth(for: touch)`, to make it work.
That is, because you might not want to use it if you have implemented a zoom feature and want to disable it while the user is zooming to get better results.

## Further Customization:

For more customization, you can modify the different properties of a brush to fit your needs.

### Line Color:

The color of a line stroke can be changed by adjusting the `color` property of a brush. SwiftyDraw accepts any UIColor:

```swift
drawView.brush.color = .red
```
    
<p align="center">
  or
</p>

```swift
drawView.brush.color = UIColor(colorLiteralRed: 0.75, green: 0.50, blue: 0.88, alpha: 1.0)
```    
### Line Width:

The width of a line stroke can be changed by adjusting the `width` property of a brush. SwiftyDraw accepts any positive CGFloat:

```swift
drawView.brush.width = CGFloat(5.0)
```

### Line Opacity:

The opacity of a line stroke can be changed by adjusting the `lineOpacity` property. SwiftyDraw accepts a CGFloat between 0. and 1.0:

```swift
drawView.brush.opacity = CGFloat(0.5)
```
    
## Editing

### Clear All:

If you wish to clear the entire canvas, simply call the `clear` function:

```swift
drawView.clear()
``` 

### Drawing History:

```swift
drawView.undo()
``` 

...and redo:

```swift
drawView.redo()
``` 
    
## Delegate

SwiftyDraw has delegate functions to notify you when a user is interacting with a SwiftDrawView. To access these delegate methods, simply make your View Controller conform to the `SwiftyDrawViewDelegate` protocol:

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
func swiftyDraw(didFinishDrawingIn drawingView: SwiftyDrawView, using touch: UITouch)
    
/// SwiftyDrawViewDelegate called when there is an issue registering touch gestures on the  SwiftyDrawView.
func swiftyDraw(didCancelDrawingIn drawingView: SwiftyDrawView, using touch: UITouch)
```
 
### Contribution

This is a project built by [Awalz](https://github.com/Awalz) and maintained & improved by [LinusGeffarth](https://github.com/LinusGeffarth).

If you would like to propose any enhancements, bug fixes, etc., feel free to create a pull request or an issue respectively.

### Contact

If you have any questions, or just want to say hi, you can reach out to me via [Twitter](https://twitter.com/linusgeffarth), or [email](mailto:linus@geffarth.com).

### LICENSE

SwiftyDraw is available under the MIT license. See the LICENSE file for more info.
