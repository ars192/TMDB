//
//  UIImageView+Extension.swift
//  TMDB
//
//  Created by Arystan on 2/10/21.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(with url: URL) {
        self.kf.setImage(with: url)
    }
}
