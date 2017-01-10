/*Copyright (c) 2016, Andrew Walz.
 
 Redistribution and use in source and binary forms, with or without modification,are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 
 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS
 BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. */

import UIKit

// MARK: Public Protocl Declarations


/// SwiftyDrawView Delegate

public protocol SwiftyDrawViewDelegate {
    
    /**
     SwiftyDrawViewDelegate called when a touch gesture begins on the SwiftyDrawView.
     
     - Parameter view: SwiftyDrawView where touches occured.
     */
    
    func SwiftyDrawDidBeginDrawing(view: SwiftyDrawView)
    
    /**
     SwiftyDrawViewDelegate called when touch gestures continue on the SwiftyDrawView.
     
     - Parameter view: SwiftyDrawView where touches occured.
     */
    
    func SwiftyDrawIsDrawing(view: SwiftyDrawView)
    
    /**
     SwiftyDrawViewDelegate called when touches gestures finish on the SwiftyDrawView.
     
     - Parameter view: SwiftyDrawView where touches occured.
     */
    
    func SwiftyDrawDidFinishDrawing(view: SwiftyDrawView)
    
    /**
     SwiftyDrawViewDelegate called when there is an issue registering touch gestures on the  SwiftyDrawView.
     
     - Parameter view: SwiftyDrawView where touches occured.
     */
    
    func SwiftyDrawDidCancelDrawing(view: SwiftyDrawView)
}

extension SwiftyDrawViewDelegate {
    
    func SwiftyDrawDidBeginDrawing(view: SwiftyDrawView) {
        //optional
    }
    
    func SwiftyDrawIsDrawing(view: SwiftyDrawView) {
        //optional
    }
    
    func SwiftyDrawDidFinishDrawing(view: SwiftyDrawView) {
        //optional
    }
    
    func SwiftyDrawDidCancelDrawing(view: SwiftyDrawView) {
        //optional
    }
}

/// UIView Subclass where touch gestures are translated into Core Graphics drawing

open class SwiftyDrawView: UIView {
    
    
    /// Line color for current drawing strokes
    public var lineColor              : UIColor   = UIColor.black
    
    /// Line width for current drawing strokes
    public var lineWidth              : CGFloat   = 10.0
    
    /// Line opacity for current drawing strokes
    public var lineOpacity            : CGFloat   = 1.0
    
    /// Sets whether touch gestures should be registered as drawing strokes on the current canvas
    public var drawingEnabled         : Bool      = true
    
    /// Public SwiftyDrawView delegate
    public var delegate               : SwiftyDrawViewDelegate?
    
    
    private var pathArray             : [Line]    = []
    private var currentPoint          : CGPoint   = CGPoint()
    private var previousPoint         : CGPoint   = CGPoint()
    private var previousPreviousPoint : CGPoint   = CGPoint()
    
    private struct Line {
        var path    : CGMutablePath
        var color   : UIColor
        var width   : CGFloat
        var opacity : CGFloat
        
        init(path : CGMutablePath, color: UIColor, width: CGFloat, opacity: CGFloat) {
            self.path    = path
            self.color   = color
            self.width   = width
            self.opacity = opacity
        }
    }
    
    /// Public init(frame:) implementation
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    /// Public init(coder:) implementation
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
    }
    
    /// Overriding draw(rect:) to stroke paths
    
    override open func draw(_ rect: CGRect) {
        let context : CGContext = UIGraphicsGetCurrentContext()!
        context.setLineCap(.round)

        for line in pathArray {
            context.setLineWidth(line.width)
            context.setAlpha(line.opacity)
            context.setStrokeColor(line.color.cgColor)
            context.addPath(line.path)
            context.beginTransparencyLayer(auxiliaryInfo: nil)
            context.strokePath()
            context.endTransparencyLayer()
        }
    }
    
    /// touchesBegan implementation to capture strokes
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard drawingEnabled == true else {
            return
        }
        
        self.delegate?.SwiftyDrawDidBeginDrawing(view: self)
        if let touch = touches.first as UITouch! {
            setTouchPoints(touch, view: self)
            let newLine = Line(path: CGMutablePath(), color: self.lineColor, width: self.lineWidth, opacity: self.lineOpacity)
            newLine.path.addPath(createNewPath())
            pathArray.append(newLine)
        }
    }
    
    /// touchesMoves implementation to capture strokes

    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard drawingEnabled == true else {
            return
        }
        
        self.delegate?.SwiftyDrawIsDrawing(view: self)
        if let touch = touches.first as UITouch! {
            updateTouchPoints(touch, view: self)
            let newLine = createNewPath()
            if let currentPath = pathArray.last {
                currentPath.path.addPath(newLine)
            }
        }
    }
    
    /// touchedEnded implementation to capture strokes

    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard drawingEnabled == true else {
            return
        }
        
        self.delegate?.SwiftyDrawDidFinishDrawing(view: self)
    }
    
    /// touchedCancelled implementation
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard drawingEnabled == true else {
            return
        }
        
        self.delegate?.SwiftyDrawDidCancelDrawing(view: self)
    }
    
    /// Remove last stroked line
    
    public func removeLastLine() {
        if pathArray.count > 0 {
            pathArray.removeLast()
        }
        setNeedsDisplay()
    }
    
    /// Clear all stroked lines on canvas
    
    public func clearCanvas() {
        pathArray = []
        setNeedsDisplay()
    }
    
/********************************** Private Functions **********************************/
    
    private func setTouchPoints(_ touch: UITouch,view: UIView) {
        previousPoint = touch.previousLocation(in: view)
        previousPreviousPoint = touch.previousLocation(in: view)
        currentPoint = touch.location(in: view)
    }
    
    private func updateTouchPoints(_ touch: UITouch,view: UIView) {
        previousPreviousPoint = previousPoint
        previousPoint = touch.previousLocation(in: view)
        currentPoint = touch.location(in: view)
    }
    
    private func createNewPath() -> CGMutablePath {
        let midPoints = getMidPoints()
        let subPath = createSubPath(midPoints.0, mid2: midPoints.1)
        let newPath = addSubPathToPath(subPath)
        return newPath
    }
    
    private func calculateMidPoint(_ p1 : CGPoint, p2 : CGPoint) -> CGPoint {
        return CGPoint(x: (p1.x + p2.x) * 0.5, y: (p1.y + p2.y) * 0.5);
    }
    
    private func getMidPoints() -> (CGPoint,  CGPoint) {
        let mid1 : CGPoint = calculateMidPoint(previousPoint, p2: previousPreviousPoint)
        let mid2 : CGPoint = calculateMidPoint(currentPoint, p2: previousPoint)
        return (mid1, mid2)
    }
    
    private func createSubPath(_ mid1: CGPoint, mid2: CGPoint) -> CGMutablePath {
        let subpath : CGMutablePath = CGMutablePath()
        subpath.move(to: CGPoint(x: mid1.x, y: mid1.y))
        subpath.addQuadCurve(to: CGPoint(x: mid2.x, y: mid2.y), control: CGPoint(x: previousPoint.x, y: previousPoint.y))
        return subpath
    }
    
    private func addSubPathToPath(_ subpath: CGMutablePath) -> CGMutablePath {
        let bounds : CGRect = subpath.boundingBox
        let drawBox : CGRect = bounds.insetBy(dx: -2.0 * lineWidth, dy: -2.0 * lineWidth)
        self.setNeedsDisplay(drawBox)
        return subpath
    }
}



    
