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

// MARK: - Public Protocol Declarations

/// SwiftyDrawView Delegate
@objc public protocol SwiftyDrawViewDelegate: AnyObject {
    
    /**
     SwiftyDrawViewDelegate called when a touch gesture should begin on the SwiftyDrawView using given touch type
     
     - Parameter view: SwiftyDrawView where touches occured.
     - Parameter touchType: Type of touch occuring.
     */
    func swiftyDraw(shouldBeginDrawingIn drawingView: SwiftyDrawView, using touch: UITouch) -> Bool
    /**
     SwiftyDrawViewDelegate called when a touch gesture begins on the SwiftyDrawView.
     
     - Parameter view: SwiftyDrawView where touches occured.
     */
    func swiftyDraw(didBeginDrawingIn drawingView: SwiftyDrawView, using touch: UITouch)
    
    /**
     SwiftyDrawViewDelegate called when touch gestures continue on the SwiftyDrawView.
     
     - Parameter view: SwiftyDrawView where touches occured.
     */
    func swiftyDraw(isDrawingIn drawingView: SwiftyDrawView, using touch: UITouch)
    
    /**
     SwiftyDrawViewDelegate called when touches gestures finish on the SwiftyDrawView.
     
     - Parameter view: SwiftyDrawView where touches occured.
     */
    func swiftyDraw(didFinishDrawingIn drawingView: SwiftyDrawView, using touch: UITouch)
    
    /**
     SwiftyDrawViewDelegate called when there is an issue registering touch gestures on the  SwiftyDrawView.
     
     - Parameter view: SwiftyDrawView where touches occured.
     */
    func swiftyDraw(didCancelDrawingIn drawingView: SwiftyDrawView, using touch: UITouch)
}

/// UIView Subclass where touch gestures are translated into Core Graphics drawing
open class SwiftyDrawView: UIView {
    
    /// Current brush being used for drawing
    public var brush: Brush = .default {
        didSet {
            previousBrush = oldValue
        }
    }
    /// Determines whether touch gestures should be registered as drawing strokes on the current canvas
    public var isEnabled = true

    /// Determines how touch gestures are treated
    /// draw - freehand draw
    /// line - draws straight lines **WARNING:** experimental feature, may not work properly.
    public enum DrawMode { case draw, line, ellipse, rect }
    public var drawMode:DrawMode = .draw
    
    /// Determines whether paths being draw would be filled or stroked.
    public var shouldFillPath = false

    /// Determines whether responde to Apple Pencil interactions, like the Double tap for Apple Pencil 2 to switch tools.
    public var isPencilInteractive : Bool = true {
        didSet {
            if #available(iOS 12.1, *) {
                pencilInteraction.isEnabled  = isPencilInteractive
            }
        }
    }
    /// Public SwiftyDrawView delegate
    @IBOutlet public weak var delegate: SwiftyDrawViewDelegate?
    
    @available(iOS 9.1, *)
    public enum TouchType: Equatable, CaseIterable {
        case finger, pencil
        
        var uiTouchTypes: [UITouch.TouchType] {
            switch self {
            case .finger:
                return [.direct, .indirect]
            case .pencil:
                return [.pencil, .stylus  ]
            }
        }
    }
    /// Determines which touch types are allowed to draw; default: `[.finger, .pencil]` (all)
    @available(iOS 9.1, *)
    public lazy var allowedTouchTypes: [TouchType] = [.finger, .pencil]
    
    public  var drawItems: [DrawItem] = []
    public  var drawingHistory: [DrawItem] = []
    public  var firstPoint: CGPoint = .zero      // created this variable
    public  var currentPoint: CGPoint = .zero     // made public
    private var previousPoint: CGPoint = .zero
    private var previousPreviousPoint: CGPoint = .zero
    
    // For pencil interactions
    @available(iOS 12.1, *)
    lazy private var pencilInteraction = UIPencilInteraction()
    
    /// Save the previous brush for Apple Pencil interaction Switch to previous tool
    private var previousBrush: Brush = .default
    
    public enum ShapeType { case rectangle, roundedRectangle, ellipse }

    public struct DrawItem {
        public var path: CGMutablePath
        public var brush: Brush
        public var isFillPath: Bool
        
        public init(path: CGMutablePath, brush: Brush, isFillPath: Bool) {
            self.path = path
            self.brush = brush
            self.isFillPath = isFillPath
        }
    }
    
    /// Public init(frame:) implementation
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        // receive pencil interaction if supported
        if #available(iOS 12.1, *) {
            pencilInteraction.delegate = self
            self.addInteraction(pencilInteraction)
        }
    }
    
    /// Public init(coder:) implementation
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .clear
        //Receive pencil interaction if supported
        if #available(iOS 12.1, *) {
            pencilInteraction.delegate = self
            self.addInteraction(pencilInteraction)
        }
    }
    
    /// Overriding draw(rect:) to stroke paths
    override open func draw(_ rect: CGRect) {
        guard let context: CGContext = UIGraphicsGetCurrentContext() else { return }
        
        for item in drawItems {
            context.setLineCap(.round)
            context.setLineJoin(.round)
            context.setLineWidth(item.brush.width)
            context.setBlendMode(item.brush.blendMode.cgBlendMode)
            context.setAlpha(item.brush.opacity)
            if (item.isFillPath)
            {
                context.setFillColor(item.brush.color.uiColor.cgColor)
                context.addPath(item.path)
                context.fillPath()
            }
            else {
                context.setStrokeColor(item.brush.color.uiColor.cgColor)
                context.addPath(item.path)
                context.strokePath()
            }
        }
    }
    
    /// touchesBegan implementation to capture strokes
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isEnabled, let touch = touches.first else { return }
        if #available(iOS 9.1, *) {
            guard allowedTouchTypes.flatMap({ $0.uiTouchTypes }).contains(touch.type) else { return }
        }
        guard delegate?.swiftyDraw(shouldBeginDrawingIn: self, using: touch) ?? true else { return }
        delegate?.swiftyDraw(didBeginDrawingIn: self, using: touch)
        
        setTouchPoints(touch, view: self)
        firstPoint = touch.location(in: self)
        let newLine = DrawItem(path: CGMutablePath(),
                           brush: Brush(color: brush.color.uiColor, width: brush.width, opacity: brush.opacity, blendMode: brush.blendMode), isFillPath: drawMode != .draw && drawMode != .line ? shouldFillPath : false)
        addLine(newLine)
    }
    
    /// touchesMoves implementation to capture strokes
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isEnabled, let touch = touches.first else { return }
        if #available(iOS 9.1, *) {
            guard allowedTouchTypes.flatMap({ $0.uiTouchTypes }).contains(touch.type) else { return }
        }
        delegate?.swiftyDraw(isDrawingIn: self, using: touch)
        
        updateTouchPoints(for: touch, in: self)
        
        switch (drawMode) {
        case .line:
            drawItems.removeLast()
            setNeedsDisplay()
            let newLine = DrawItem(path: CGMutablePath(),
                               brush: Brush(color: brush.color.uiColor, width: brush.width, opacity: brush.opacity, blendMode: brush.blendMode), isFillPath: false)
            newLine.path.addPath(createNewStraightPath())
            addLine(newLine)
            break
        case .draw:
            let newPath = createNewPath()
            if let currentPath = drawItems.last {
                currentPath.path.addPath(newPath)
            }
            break
        case .ellipse:
            drawItems.removeLast()
            setNeedsDisplay()
            let newLine = DrawItem(path: CGMutablePath(),
                               brush: Brush(color: brush.color.uiColor, width: brush.width, opacity: brush.opacity, blendMode: brush.blendMode), isFillPath: shouldFillPath)
            newLine.path.addPath(createNewShape(type: .ellipse))
            addLine(newLine)
            break
        case .rect:
            drawItems.removeLast()
            setNeedsDisplay()
            let newLine = DrawItem(path: CGMutablePath(),
                               brush: Brush(color: brush.color.uiColor, width: brush.width, opacity: brush.opacity, blendMode: brush.blendMode), isFillPath: shouldFillPath)
            newLine.path.addPath(createNewShape(type: .rectangle))
            addLine(newLine)
            break
        }
    }
    
    func addLine(_ newLine: DrawItem) {
        drawItems.append(newLine)
        drawingHistory = drawItems // adding a new item should also update history
    }
    
    /// touchedEnded implementation to capture strokes
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isEnabled, let touch = touches.first else { return }
        delegate?.swiftyDraw(didFinishDrawingIn: self, using: touch)
    }
    
    /// touchedCancelled implementation
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isEnabled, let touch = touches.first else { return }
        delegate?.swiftyDraw(didCancelDrawingIn: self, using: touch)
    }
    
    /// Displays paths passed by replacing all other contents with provided paths
    public func display(drawItems: [DrawItem]) {
        self.drawItems = drawItems
        drawingHistory = drawItems
        setNeedsDisplay()
    }
    
    /// Determines whether a last change can be undone
    public var canUndo: Bool {
        return drawItems.count > 0
    }
    
    /// Determines whether an undone change can be redone
    public var canRedo: Bool {
        return drawingHistory.count > drawItems.count
    }
    
    /// Undo the last change
    public func undo() {
        guard canUndo else { return }
        drawItems.removeLast()
        setNeedsDisplay()
    }
    
    /// Redo the last change
    public func redo() {
        guard canRedo, let line = drawingHistory[safe: drawItems.count] else { return }
        drawItems.append(line)
        setNeedsDisplay()
    }
    
    /// Clear all stroked lines on canvas
    public func clear() {
        drawItems = []
        setNeedsDisplay()
    }
    
    /********************************** Private Functions **********************************/
    
    private func setTouchPoints(_ touch: UITouch,view: UIView) {
        previousPoint = touch.previousLocation(in: view)
        previousPreviousPoint = touch.previousLocation(in: view)
        currentPoint = touch.location(in: view)
    }
    
    private func updateTouchPoints(for touch: UITouch,in view: UIView) {
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
    
    private func createNewStraightPath() -> CGMutablePath {
        let pt1 : CGPoint = firstPoint
        let pt2 : CGPoint = currentPoint
        let subPath = createStraightSubPath(pt1, mid2: pt2)
        let newPath = addSubPathToPath(subPath)
        return newPath
    }
    
    private func createNewShape(type :ShapeType, corner:CGPoint = CGPoint(x: 1.0, y: 1.0)) -> CGMutablePath {
        let pt1 : CGPoint = firstPoint
        let pt2 : CGPoint = currentPoint
        let width = abs(pt1.x - pt2.x)
        let height = abs(pt1.y - pt2.y)
        let newPath = CGMutablePath()
        if width > 0, height > 0 {
            let bounds = CGRect(x: min(pt1.x, pt2.x), y: min(pt1.y, pt2.y), width: width, height: height)
            switch (type) {
            case .ellipse:
                newPath.addEllipse(in: bounds)
                break
            case .rectangle:
                newPath.addRect(bounds)
                break
            case .roundedRectangle:
                newPath.addRoundedRect(in: bounds, cornerWidth: corner.x, cornerHeight: corner.y)
            }
        }
        return addSubPathToPath(newPath)
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
    
    private func createStraightSubPath(_ mid1: CGPoint, mid2: CGPoint) -> CGMutablePath {
        let subpath : CGMutablePath = CGMutablePath()
        subpath.move(to: mid1)
        subpath.addLine(to: mid2)
        return subpath
    }
    
    private func addSubPathToPath(_ subpath: CGMutablePath) -> CGMutablePath {
        let bounds : CGRect = subpath.boundingBox
        let drawBox : CGRect = bounds.insetBy(dx: -2.0 * brush.width, dy: -2.0 * brush.width)
        self.setNeedsDisplay(drawBox)
        return subpath
    }
}

// MARK: - Extensions

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

@available(iOS 12.1, *)
extension SwiftyDrawView : UIPencilInteractionDelegate{
    public func pencilInteractionDidTap(_ interaction: UIPencilInteraction) {
        let preference = UIPencilInteraction.preferredTapAction
        if preference == .switchEraser {
            let currentBlend = self.brush.blendMode
            if currentBlend != .clear {
                self.brush.blendMode = .clear
            } else {
                self.brush.blendMode = .normal
            }
        } else if preference == .switchPrevious {
            self.brush = self.previousBrush
        }
    }
}
