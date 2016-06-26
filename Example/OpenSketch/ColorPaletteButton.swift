//
//  colorPaletteButton.swift
//  OpenSketch
//
//  Created by Andrew on 2016-01-06.
//

import UIKit

class ColorPaletteButton: UIButton {
    
    var fillColor = UIColor.white().cgColor
    override func draw(_ rect:CGRect)
    {
        let context = UIGraphicsGetCurrentContext()
        let rad = rect.width/2-2
        let endAngle = CGFloat(2*M_PI)
        context?.addArc(centerX: rect.midX, y: rect.midY, radius: rad, startAngle: 0, endAngle: endAngle, clockwise: 1)
        context?.setFillColor(fillColor)
        context?.setStrokeColor(UIColor.black().cgColor)
        context?.setLineWidth(3.0)
        context?.drawPath(using: CGPathDrawingMode.fillStroke);
    }
}

class RedButton: ColorPaletteButton {
    override func draw(_ rect: CGRect) {
        fillColor = UIColor.red().cgColor
        super.draw(rect)
    }
}

class BlueButton: ColorPaletteButton {
    override func draw(_ rect: CGRect) {
        fillColor = UIColor.blue().cgColor
        super.draw(rect)
    }
}

class GreenButton: ColorPaletteButton {
    override func draw(_ rect: CGRect) {
        fillColor = UIColor.green().cgColor
        super.draw(rect)
    }
}

class YellowButton: ColorPaletteButton {
    override func draw(_ rect: CGRect) {
        fillColor = UIColor.yellow().cgColor
        super.draw(rect)
    }
}

class PurpleButton: ColorPaletteButton {
    override func draw(_ rect: CGRect) {
        fillColor = UIColor.purple().cgColor
        super.draw(rect)
    }
}

class OrangeButton: ColorPaletteButton {
    override func draw(_ rect: CGRect) {
        fillColor = UIColor.orange().cgColor
        super.draw(rect)
    }
}


