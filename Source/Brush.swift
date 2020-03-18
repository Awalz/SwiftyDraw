//
//  Brush.swift
//  Sketch
//
//  Created by Linus Geffarth on 02.05.18.
//  Copyright © 2018 Linus Geffarth. All rights reserved.
//

import UIKit

public class Brush: Codable {
    
    public var color: Color
    /// Original brush width set when initializing the brush. Not affected by updating the brush width. Used to determine adjusted width
    private var _originalWidth: CGFloat
    /// Original brush width set when initializing the brush. Not affected by updating the brush width. Used to determine adjusted width
    public var originalWidth: CGFloat { return _originalWidth }
    public var width: CGFloat
    public var opacity: CGFloat
    
    public var adjustedWidthFactor: CGFloat = 1
    
    /// Allows for actually erasing content, by setting it to `.clear`. Default is `.normal`
    public var blendMode: BlendMode = .normal
    
    public init(color: UIColor = .black, width: CGFloat = 3, opacity: CGFloat = 1, adjustedWidthFactor: CGFloat = 1, blendMode: BlendMode = .normal) {
        self.color = Color(color)
        self._originalWidth = width
        self.width = width
        self.opacity = opacity
        self.adjustedWidthFactor = adjustedWidthFactor
        self.blendMode = blendMode
    }
    
    private func adjustedWidth(for touch: UITouch) -> CGFloat {
        guard #available(iOS 9.1, *), touch.type == .pencil else { return originalWidth }
        return (originalWidth*(1-adjustedWidthFactor/10*2)) + (adjustedWidthFactor/touch.altitudeAngle)
    }
    
    public func adjustWidth(for touch: UITouch) {
        width = adjustedWidth(for: touch)
    }
    
    // MARK: - Static brushes
    
    public static var `default`: Brush {
        return Brush(color: .black, width: 3, opacity: 1)
    }
    
    public static var thin: Brush {
        return Brush(color: .black, width: 2, opacity: 1)
    }
    
    public static var medium: Brush {
        return Brush(color: .black, width: 7, opacity: 1)
    }
    
    public static var thick: Brush {
        return Brush(color: .black, width: 10, opacity: 1)
    }
    
    public static var marker: Brush {
        return Brush(color: #colorLiteral(red: 0.920953393, green: 0.447560966, blue: 0.4741248488, alpha: 1), width: 10, opacity: 0.3)
    }
    
    public static var eraser: Brush {
        return Brush(adjustedWidthFactor: 5, blendMode: .clear)
    }
    
    public static var selection: Brush {
        return Brush(color: .clear, width: 1, opacity: 1)
    }
}

extension Brush: Equatable, Comparable, CustomStringConvertible {
    
    public static func ==(lhs: Brush, rhs: Brush) -> Bool {
        return (
          lhs.color.uiColor == rhs.color.uiColor &&
                lhs.originalWidth == rhs.originalWidth &&
                lhs.opacity == rhs.opacity
        )
    }
    
    public static func <(lhs: Brush, rhs: Brush) -> Bool {
        return (
            lhs.width < rhs.width
        )
    }
    
    public var description: String {
        return "<Brush: color: \(color), width: (original: \(originalWidth), current: \(width)), opacity: \(opacity)>"
    }
}
