//
//  SwiftyLine.swift
//  OpenSketch
//
//  Created by Andrew on 2016-01-06.
//

import UIKit

    var lineColor : UIColor = UIColor.blackColor()
    var lineWidth : CGFloat = 10.0
    var lineOpacity : CGFloat = 1.0

class SwiftyLine: UIView {
    
    var defaultBackgroundColor : UIColor = UIColor.clearColor()
    var currentPoint: CGPoint = CGPoint()
    var previousPoint : CGPoint = CGPoint()
    var previousPreviousPoint : CGPoint = CGPoint()
    var pointCount: Int = Int()
    var pointArray = [Int]()
    var pathArray = [line]()
    
    struct line {
        var structLineColor : UIColor
        var structLineWidth : CGFloat
        var structPath : CGMutablePathRef
        var structOpacity : CGFloat
        
        init(newPath : CGMutablePathRef) {
            structLineColor = lineColor
            structLineWidth = lineWidth
            structPath = newPath
            structOpacity = lineOpacity
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = defaultBackgroundColor

    }
    
    override func drawRect(rect: CGRect) {
        for line in pathArray {
            let context : CGContextRef = UIGraphicsGetCurrentContext()!
            CGContextAddPath(context, line.structPath)
            CGContextSetLineWidth(context, line.structLineWidth)
            CGContextSetStrokeColorWithColor(context, line.structLineColor.CGColor)
            CGContextSetAlpha(context, lineOpacity)
            CGContextSetLineCap(context, CGLineCap.Round)
            CGContextBeginTransparencyLayer(context, nil)
            CGContextStrokePath(context)
            CGContextEndTransparencyLayer(context)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first as UITouch! {
            setTouchPoints(touch, view: self)
            pointCount = 0
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
         if let touch = touches.first as UITouch! {
            updateTouchPoints(touch, view: self)
            addSubPathToPath(createSubPath(getMidPoints().0, mid2: getMidPoints().1))
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        pointArray.append(pointCount)
    }
    
    func setTouchPoints(touch: UITouch,view: UIView) {
        previousPoint = touch.previousLocationInView(view)
        previousPreviousPoint = touch.previousLocationInView(view)
        currentPoint = touch.locationInView(view)
    }
    
    func updateTouchPoints(touch: UITouch,view: UIView) {
        previousPreviousPoint = previousPoint
        previousPoint = touch.previousLocationInView(view)
        currentPoint = touch.locationInView(view)
    }
    
    
    func calculateMidPoint(p1 : CGPoint, p2 : CGPoint) -> CGPoint {
        return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
    }
    
    func getMidPoints() -> (CGPoint,  CGPoint) {
        let mid1 : CGPoint = calculateMidPoint(previousPoint, p2: previousPreviousPoint)
        let mid2 : CGPoint = calculateMidPoint(currentPoint, p2: previousPoint)
        return (mid1, mid2)
    }
    
    func createSubPath(mid1: CGPoint, mid2: CGPoint) -> CGMutablePathRef {
        let subpath : CGMutablePathRef = CGPathCreateMutable()
        CGPathMoveToPoint(subpath, nil, mid1.x, mid1.y)
        CGPathAddQuadCurveToPoint(subpath, nil, previousPoint.x, previousPoint.y, mid2.x, mid2.y)
        return subpath
    }
    
    func addSubPathToPath(subpath: CGMutablePathRef) {
        let bounds : CGRect = CGPathGetBoundingBox(subpath)
        let drawBox : CGRect = CGRectInset(bounds, -2.0 * lineWidth, -2.0 * lineWidth)
        let newLine = line(newPath: subpath)
        pathArray.append(newLine)
        self.setNeedsDisplayInRect(drawBox)
        pointCount++
    }
    
    func removeLastPath() {
        if pathArray.count > 0 || pointArray.count > 0 {
            for var index = 0; index < pointArray.last; ++index {
                if pathArray.count > 0 {
                    pathArray.removeLast()
                }
            }
            pointArray.removeLast()
        }
        setNeedsDisplay()
    }
    
    func removeAllPaths() {
        pathArray = []
        pointArray = []
        setNeedsDisplay()
    }
    
    func changeLineColor(color: UIColor) {
        lineColor = color
    }
    
    func changeLineWidth(width: CGFloat) {
        lineWidth = width
    }
}



    