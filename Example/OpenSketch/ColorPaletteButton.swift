//
//  colorPaletteButton.swift
//  OpenSketch
//
//  Created by Andrew on 2016-01-06.
//

import UIKit

class ColorPaletteButton: UIButton {
    
    var fillColor = UIColor.whiteColor().CGColor
    override func drawRect(rect:CGRect)
    {
        let context = UIGraphicsGetCurrentContext()
        let rad = CGRectGetWidth(rect)/2-2
        let endAngle = CGFloat(2*M_PI)
        CGContextAddArc(context, CGRectGetMidX(rect), CGRectGetMidY(rect), rad, 0, endAngle, 1)
        CGContextSetFillColorWithColor(context,fillColor)
        CGContextSetStrokeColorWithColor(context,UIColor.blackColor().CGColor)
        CGContextSetLineWidth(context, 3.0)
        CGContextDrawPath(context, CGPathDrawingMode.FillStroke);
    }
}

class RedButton: ColorPaletteButton {
    override func drawRect(rect: CGRect) {
        fillColor = UIColor.redColor().CGColor
        super.drawRect(rect)
    }
}

class BlueButton: ColorPaletteButton {
    override func drawRect(rect: CGRect) {
        fillColor = UIColor.blueColor().CGColor
        super.drawRect(rect)
    }
}

class GreenButton: ColorPaletteButton {
    override func drawRect(rect: CGRect) {
        fillColor = UIColor.greenColor().CGColor
        super.drawRect(rect)
    }
}

class YellowButton: ColorPaletteButton {
    override func drawRect(rect: CGRect) {
        fillColor = UIColor.yellowColor().CGColor
        super.drawRect(rect)
    }
}

class PurpleButton: ColorPaletteButton {
    override func drawRect(rect: CGRect) {
        fillColor = UIColor.purpleColor().CGColor
        super.drawRect(rect)
    }
}

class OrangeButton: ColorPaletteButton {
    override func drawRect(rect: CGRect) {
        fillColor = UIColor.orangeColor().CGColor
        super.drawRect(rect)
    }
}


