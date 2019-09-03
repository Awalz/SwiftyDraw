//
//  Extensions.swift
//  SwiftyDrawExample
//
//  Created by Linus Geffarth on 22.02.19.
//  Copyright © 2019 Walzy. All rights reserved.
//

import UIKit

@IBDesignable
extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        set { layer.cornerRadius = newValue }
        get { return layer.cornerRadius }
    }
    
    @IBInspectable var borderColor: UIColor {
        set { layer.borderColor = newValue.cgColor }
        get { return UIColor(cgColor: layer.borderColor!) }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        set { layer.borderWidth = newValue }
        get { return layer.borderWidth }
    }
}

extension CGMutablePath {
    func adding(path: CGPath) -> CGMutablePath {
        addPath(path)
        return self
    }
}
