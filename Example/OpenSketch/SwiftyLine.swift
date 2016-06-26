//
//  SwiftyLine.swift
//  OpenSketch
//
//  Created by Andrew on 2016-01-06.
//

import UIKit

class SwiftyLine: UIView {
    
    var lineColor : UIColor = UIColor.black()
    var lineWidth : CGFloat = 10.0
    var lineOpacity : CGFloat = 0.4
    
    struct Line {
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
 
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear()
    }
    
    
    func removeLastPath() {
        if pathArray.count > 0 {
            pathArray.removeLast()
        }
        setNeedsDisplay()
    }
    
    func removeAllPaths() {
        pathArray = []
        setNeedsDisplay()
    }
    
    private var pathArray = [Line]()

    
    override func draw(_ rect: CGRect) {
        for line in pathArray {
            let context : CGContext = UIGraphicsGetCurrentContext()!
            context.addPath(line.path)
            context.setLineWidth(line.width)
            context.setStrokeColor(line.color.cgColor)
            context.setAlpha(lineOpacity)
            context.setLineCap(CGLineCap.round)
            context.strokePath()
        }
    }
    
    private var currentPoint: CGPoint = CGPoint()
    private var previousPoint : CGPoint = CGPoint()
    private var previousPreviousPoint : CGPoint = CGPoint()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first as UITouch! {
            setTouchPoints(touch, view: self)
            let newLine = Line(path: CGMutablePath(), color: self.lineColor, width: self.lineWidth, opacity: self.lineOpacity)
            newLine.path.addPath(nil, path: addSubPathToPath(createSubPath(getMidPoints().0, mid2: getMidPoints().1)))
            pathArray.append(newLine)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
         if let touch = touches.first as UITouch! {
            updateTouchPoints(touch, view: self)
            let newLine = addSubPathToPath(createSubPath(getMidPoints().0, mid2: getMidPoints().1))
            if let currentPath = pathArray.last {
                currentPath.path.addPath(nil, path: newLine)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
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
    
    func addSubPathToPath(_ subpath: CGMutablePath) -> CGMutablePath {
        let bounds : CGRect = subpath.boundingBox
        let drawBox : CGRect = bounds.insetBy(dx: -2.0 * lineWidth, dy: -2.0 * lineWidth)
        self.setNeedsDisplay(drawBox)
        return subpath
    }
}



    
