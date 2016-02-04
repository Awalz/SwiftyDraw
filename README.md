#SwiftyLine

##A Lightweight drawing library built in Swift
SwiftyLine is a subclass of UIView which uses Core Graphics and UIResponder to allow drawing on any canvas.

#Requirements

* IOS 7.0
* XCode 7.2

##Usage

Create an instance of SwiftyLine:

    var smoothLineView : SwiftyLine = SwiftyLine()

Then in viewDidLoad, initialize the view(such as a UIImageView) with the frame:

    smoothLineView = SwiftyLine(frame: canvas.bounds)
    
##Features

###Color
Line color can be changed by passing a UIColor to the **changeLineColor()** function:

    smoothLineView.changeLineColor(UIColor.blueColor())

###Width
Line width can be changed by passing a CGFloat to the **changeLineWidth()** function:

    let width : CGFloat = 5.0
    smoothLineView.changeLineWidth(width)    
    
    
###Delete 

All of the line segments drawn are stored in an array. To remove all drawn lines are clear the drawing canvas, use the **removeAllPaths()** function:

    smoothLineView.removeAllPaths()
    
###Remove Last Path

To remove the last line segment drawn, use the removeLastPath() function: 

    smoothLineView.removeLastPath()
    
##Todo-List

* Get alpha values to work
* Extend UIColor to accept RGB and hex values










