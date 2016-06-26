//
//  SwiftyLine.swift
//  OpenSketch
//
//  Created by Andrew on 2016-01-06.
//

import UIKit

struct line {
    var path : CGMutablePath
    var color : UIColor
    var width : CGFloat
    var opacity : CGFloat
    
    init(path : CGMutablePath, color: UIColor, width: CGFloat, opacity: CGFloat) {
        self.path = path
        self.color = color
        self.width = width
        self.opacity = opacity
    }
}


class SwiftyLine: UIView {
    
    var currentPoint: CGPoint = CGPoint()
    var previousPoint : CGPoint = CGPoint()
    var previousPreviousPoint : CGPoint = CGPoint()
    var lineColor : UIColor = UIColor.black()
    var lineWidth : CGFloat = 10.0
    var lineOpacity : CGFloat = 1.0

    var pointCount: Int = Int()
    var pointArray = [Int]()
    var pathArray = [line]()
 
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear()
    }
    
    override func draw(_ rect: CGRect) {
        for line in pathArray {
            let context : CGContext = UIGraphicsGetCurrentContext()!
            context.addPath(line.path)
            context.setLineWidth(line.width)
            context.setStrokeColor(line.color.cgColor)
            context.setAlpha(lineOpacity)
            context.setLineCap(CGLineCap.round)
            context.beginTransparencyLayer(auxiliaryInfo: nil)
            context.strokePath()
            context.endTransparencyLayer()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first as UITouch! {
            setTouchPoints(touch, view: self)
            pointCount = 0
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
         if let touch = touches.first as UITouch! {
            updateTouchPoints(touch, view: self)
            addSubPathToPath(createSubPath(getMidPoints().0, mid2: getMidPoints().1))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        pointArray.append(pointCount)
        print(pathArray.count)
    }
    
    func setTouchPoints(_ touch: UITouch,view: UIView) {
        previousPoint = touch.previousLocation(in: view)
        previousPreviousPoint = touch.previousLocation(in: view)
        currentPoint = touch.location(in: view)
    }
    
    func updateTouchPoints(_ touch: UITouch,view: UIView) {
        previousPreviousPoint = previousPoint
        previousPoint = touch.previousLocation(in: view)
        currentPoint = touch.location(in: view)
    }
    
    
    func calculateMidPoint(_ p1 : CGPoint, p2 : CGPoint) -> CGPoint {
        return CGPoint(x: (p1.x + p2.x) * 0.5, y: (p1.y + p2.y) * 0.5);
    }
    
    func getMidPoints() -> (CGPoint,  CGPoint) {
        let mid1 : CGPoint = calculateMidPoint(previousPoint, p2: previousPreviousPoint)
        let mid2 : CGPoint = calculateMidPoint(currentPoint, p2: previousPoint)
        return (mid1, mid2)
    }
    
    func createSubPath(_ mid1: CGPoint, mid2: CGPoint) -> CGMutablePath {
        let subpath : CGMutablePath = CGMutablePath()
        subpath.moveTo(nil, x: mid1.x, y: mid1.y)
        subpath.addQuadCurve(nil, cpx: previousPoint.x, cpy: previousPoint.y, endingAtX: mid2.x, y: mid2.y)
        return subpath
    }
    
    func addSubPathToPath(_ subpath: CGMutablePath) {
        let bounds : CGRect = subpath.boundingBox
        let drawBox : CGRect = bounds.insetBy(dx: -2.0 * lineWidth, dy: -2.0 * lineWidth)
        let newLine = line(path: subpath, color: lineColor, width: lineWidth, opacity: lineOpacity)
        pathArray.append(newLine)
        self.setNeedsDisplay(drawBox)
        pointCount += 1
    }
    
    func removeLastPath() {
        if pathArray.count > 0 || pointArray.count > 0 {
            
            for _ in pointArray {
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
    
    func changeLineColor(_ color: UIColor) {
        lineColor = color
    }
    
    func changeLineWidth(_ width: CGFloat) {
        lineWidth = width
    }
}



    
