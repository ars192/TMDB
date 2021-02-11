//
//  String+Extension.swift
//  TMDB
//
//  Created by Arystan on 2/10/21.
//

import Foundation
import UIKit

extension String {

    var utfData: Data {
        return Data(utf8)
    }

    var attributedHtmlString: NSAttributedString? {

        do {
            return try NSAttributedString(data: utfData,
            options: [
                      .documentType: NSAttributedString.DocumentType.html,
                      .characterEncoding: String.Encoding.utf8.rawValue
                     ], documentAttributes: nil)
        } catch {
            print("Error:", error)
            return nil
        }
    }
}

extension UILabel {
   func setAttributedHtmlText(_ html: String) {
    if let attributedText = html.attributedHtmlString?.string {
        self.text = attributedText
      }
   }
}
