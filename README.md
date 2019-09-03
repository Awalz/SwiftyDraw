<h1 align="center">SwiftyDraw</h1>

<p align="center">
    <img src="https://img.shields.io/badge/platform-iOS%209%2B-blue.svg?style=flat" alt="Platform: iOS 9.1+"/>
    <a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/language-swift%205-4BC51D.svg?style=flat" alt="Language: Swift 5" /></a>
    <a href="https://cocoapods.org/pods/SwiftyDraw"><img src="https://img.shields.io/cocoapods/v/SwiftyDraw.svg?style=flat" alt="CocoaPods" /></a>
    <img src="http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat" alt="License: MIT" /> <br><br>
</p>


## Overview

SwiftyDraw is a simple, light-weight drawing framework written in Swift. SwiftyDraw is built using Core Gaphics and is very easy to implement.

## Requirements
* iOS 9.1+
* Swift 5.0

## Installation

### Cocoapods:

SwiftyDraw is available through [CocoaPods](http://cocoapods.org). To install
it, add the following line to your Podfile:

```ruby
pod 'SwiftyDraw'
```

### Carthage

SwiftyDraw is also available through [Carthage](https://github.com/Carthage/Carthage/blob/master/README.md). To install, add the following line to your Cartfile:

```ruby
github "awalz/SwiftyDraw" "master"
```

### Manual Installation:

Simply copy the contents of the Source folder into your project.

## Usage

Using SwiftyDraw is very simple:

### Getting Started:

Create a SwiftyDrawView and add it to your ViewController:

```swift
let drawView = SwiftyDrawView(frame: self.view.frame)
self.view.addSubview(drawView)
```

By default, the view will automatically respond to touch gestures and begin drawing. The default brush is `.default`, which has a **black** color.

To disable drawing, simply set the `isEnabled` property to `false`:

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
public static var marker   : Brush { get } // flat red-ish, width 10
public static var eraser   : Brush { get } // clear, width 8; uses CGBlendMode to erase things
```

### Adjusted Width Factor

`SwiftyDrawView` supports drawing-angle-adjusted brushes. This effectively means, if the user (using an Pencil) draws with the tip of the pencil, the brush will reduce its width a little. If the user draws at a very low angle, with the side of the pencil, the brush will be a little thicker.
You can modify this behavior by setting `adjustedWidthFactor` of a brush. If you increase the number (to, say, `5`) the changes will increase. If you reduce the number to `0`, the width will not be adjusted at all.
The default value is `1` which causes a slight de-/increase in width.

This is an opt-in feature. That means, in `shouldBeginDrawingIn`, you need to call `drawingView.brush.adjustWidth(for: touch)`.

## Further Customization:

For more customization, you can modify the different properties of a brush to fit your needs.

### Line Color:

The color of a line stroke can be changed by adjusting the `color` property of a brush. SwiftyDraw accepts any `Color`:

```swift
drawView.brush.color = Color(.red)
```
    
<p align="center">
  or
</p>

```swift
drawView.brush.color = Color(UIColor(colorLiteralRed: 0.75, green: 0.50, blue: 0.88, alpha: 1.0))
```

We have our own implementation of `UIColor` – `Color` – to be able to de-/encode it.

### Line Width:

The width of a line stroke can be changed by adjusting the `width` property of a brush. SwiftyDraw accepts any positive `CGFloat`:

```swift
drawView.brush.width = 5.0
```

### Line Opacity:

The opacity of a line stroke can be changed by adjusting the `lineOpacity` property. SwiftyDraw accepts any `CGFloat` between `0` and `1`:

```swift
drawView.brush.opacity = 0.5
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

To en-/disable custom un- & redo buttons, you can use `.canUndo` and `.canRedo`.

## Apple Pencil Integration
Apple Pencil can be used for drawing in a SwiftyDrawView, just like a finger.  
Special features, however, regarding Apple Pencil 2 are only supported on iOS 12.1 and above versions.

### Apple Pencil 2 Double Tap action
#### Enable/ Disable pencil interaction
Apple Pencil interaction is enabled by default, but you can set `drawView.isPencilInteractive` to change that setting.
#### Pencil Events
When double tapping the pencil, SwiftyDraw will check the user preferences set in the system. If the preference is set to switch to eraser, SwiftyDraw will switch between normal and erasing mode; if set to last used tool, SwiftyDraw will switch between current and previous brush.

## Delegate

SwiftyDraw has delegate functions to notify you when a user is interacting with a SwiftDrawView. To access these delegate methods, have your View Controller conform to the `SwiftyDrawViewDelegate` protocol:

```swift
class ViewController: UIViewController, SwiftyDrawViewDelegate
```

### Delegate methods

```swift
func swiftyDraw(shouldBeginDrawingIn drawingView: SwiftyDrawView, using touch: UITouch) -> Bool

func swiftyDraw(didBeginDrawingIn drawingView: SwiftyDrawView, using touch: UITouch)

func swiftyDraw(isDrawingIn drawingView: SwiftyDrawView, using touch: UITouch)
    
func swiftyDraw(didFinishDrawingIn drawingView: SwiftyDrawView, using touch: UITouch)
    
func swiftyDraw(didCancelDrawingIn drawingView: SwiftyDrawView, using touch: UITouch)
```

---
 
## Contribution

This project was built by [Awalz](https://github.com/Awalz) and is mostly maintained & improved by [LinusGeffarth](https://github.com/LinusGeffarth).

If you'd like to propose any enhancements, bug fixes, etc., feel free to create a pull request or an issue respectively.

### Contact

If you have any questions, or just want to say *Hi!*, you can reach me via [Twitter](https://twitter.com/linusgeffarth), or [email](mailto:linus@geffarth.com).

### LICENSE

SwiftyDraw is available under the MIT license. See the LICENSE file for more info.
