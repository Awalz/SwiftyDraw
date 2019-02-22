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
}
