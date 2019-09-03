//
//  Color.swift
//  SwiftyDrawExample
//
//  Created by Linus Geffarth on 17.04.19.
//  Copyright © 2019 Walzy. All rights reserved.
//

import UIKit

public class Color: UIColor, Codable {
    required public convenience init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let hexString = try container.decode(String.self)
        self.init(hex: hexString)
    }
    
    public override func encode(with aCoder: NSCoder) {
        aCoder.encode(hex)
    }
    
    public convenience init(_ uiColor: UIColor) {
        self.init(cgColor: uiColor.cgColor)
    }
}

public enum BlendMode: String, Codable {
    case normal = "normal"
    case clear = "clear"
    
    var cgBlendMode: CGBlendMode {
        switch self {
        case .normal:
            return .normal
        case .clear:
            return .clear
        }
    }
}

extension UIColor {
    convenience init(hex: String) {
        guard let hex: String = hex.searchFor(pattern: "[A-F0-9]{6}").first else { self.init(); return }
        
        var rgbValue: UInt32 = 0
        Scanner(string: hex).scanHexInt32(&rgbValue)
        let red = (rgbValue & 0xFF0000) >> 16
        let green = (rgbValue & 0x00FF00) >> 8
        let blue = (rgbValue & 0x0000FF)
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    var hex: String {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb: Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}

extension String {
    func searchFor(pattern: String) -> [String] {
        var output: [String] = []
        
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
            let matches = regex.matches(in: self, options: [], range: NSMakeRange(0, utf16.count)) as Array<NSTextCheckingResult>
            for match in matches {
                let str = (self as NSString).substring(with: match.range)
                output.append(str)
            }
        } catch { print("ERROR: searchFor regex (\(pattern)) on string (\(self)) failed: \(error)") }
        return output
    }
}
