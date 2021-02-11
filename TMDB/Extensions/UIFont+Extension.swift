//
//  UIFont+Extension.swift
//  TMDB
//
//  Created by Arystan on 2/10/21.
//

import UIKit

extension UIFont {
    static func medium(size: CGFloat = 27) -> UIFont? {
        let font = UIFont(name: "Arial-BoldMT", size: size)
        return font
    }
    
    static func light(size: CGFloat = 18) -> UIFont? {
        let font = UIFont(name: "ArialMT", size: size)
        return font
    }
}
