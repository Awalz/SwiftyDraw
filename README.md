<h1 align="center">SwiftyDraw</h1>

<p align="center">
    <img src="https://img.shields.io/badge/platform-iOS%208%2B-blue.svg?style=flat" alt="Platform: iOS 8+"/>
    <a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/language-swift%203-4BC51D.svg?style=flat" alt="Language: Swift 3" /></a>
    <a href="https://cocoapods.org/pods/SwiftyCam"><img src="https://img.shields.io/cocoapods/v/SwiftyDraw.svg?style=flat" alt="CocoaPods compatible" /></a>
    <img src="http://img.shields.io/badge/license-BSD-lightgrey.svg?style=flat" alt="License: BSD" /> <br><br>
</p>

## Overview

SwiftyDraw is a simple, lightweight drawing framework written in Swift. SwiftyDraw is built using Core Gaphics and is very easy to implement.

## Requirements
* iOS 8.0+
* Swift 3.0

## License

SwiftyDraw  is available under the BSD license. See the LICENSE file for more info.

## Installation

### Cocoapods:

SwiftyDraw is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SwiftyDraw"
```

### Manual Installation:

Simply copy the contents of the Source folder into your project.

## Usage

Using SwiftyDraw is very simple.

### Getting Started:

Simply create a SwiftyDrawView and add it to your View Controller:

    let drawView = SwiftyDrawView(frame: self.view.frame)
    self.view.addSubview(drawView)
    
By default, the view will automatically respond to touch gestures and begin drawing. The default color is **black**.

To disable color, simply set the **drawingEnabled** property to false:

    drawView.drawingEnabled = false
    
## Customization

### Line Color:

The color of a line stoke can be changed by adjusting the **lineColor** property. SwiftyDraw accepts any UIColor:

    drawView.lineColor = UIColor.red
    
<p align="center">
  or
</p>
    drawView.lineColor = UIColor(colorLiteralRed: 0.75, green: 0.50, blue: 0.88, alpha: 1.0)
    
### Line Width:

The with of a line stroke can be changed by adjusting the **lineWidth** property. SwiftyDraw accepts any positive CGFloat:

    drawView.lineWidth = CGFloat(5.0)

### Line Opacity:

The opacity of a line stoke can be changed by adjusting the **lineOpacity** property. SwiftyDraw accepts a CGFloat between 0. and 1.0:

    drawView.lineOpacity = CGFloat(0.5)
    
## Editing

### Remove Last Line:

SwiftyDraw has the option to clear the last line segment. Simply call the **removeLastLine** function:

    drawView.removeLastLine()

This can be called several times, or until the canvas is clear.


### Clear All:

If you wish to clear the entire canvas, simply call the **clearCanvas** function:

    drawView.clearCanvas()
    
## Delegate

SwiftyDraw has delegate functions to notify you when a user is interacting with a SwiftDrawView. To access these delegate methods, simply add your View Controller as the **SwiftyDrawViewDelegate**:

    class ViewController: UIViewController, SwiftyDrawViewDelegate
    
There are four optional delegat methods:

**SwiftyDrawDidBeginDrawing(view: SwiftyDrawView)** - Called when the SwiftyDrawView detects touches have begun.

**SwiftyDrawIsDrawing(view: SwiftyDrawView)** - Called when the SwiftyDrawView detects touches are currrently occuring. Will be called multiple times.

**SwiftyDrawDidFinishDrawing(view: SwiftyDrawView)** - Called when the SwiftyDrawView detects touches have ended for the particular line segment

**SwiftyDrawDidCancelDrawing(view: SwiftyDrawView)** - Called if SwiftyDrawView detects issues with the gesture recognizers and cancels the drawing

 
### Contact

If you have any questions, requests, or enhancements, feel free to submit a pull request, create an issue, or contact me in person:

**Andrew Walz**
**andrewjwalz@gmail.com**


