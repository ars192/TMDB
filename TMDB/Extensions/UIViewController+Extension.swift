//
//  UIViewController+Extension.swift
//  TMDB
//
//  Created by Arystan on 2/10/21.
//

import Foundation
import UIKit

extension UIViewController {
    func noInternetConnection() {
        let noInternetLabel = UILabel()
        noInternetLabel.textColor = .black
        noInternetLabel.backgroundColor = .red
        noInternetLabel.font = UIFont.medium(size: 18)
        noInternetLabel.text = "Slow or no internet connection!"
        noInternetLabel.textAlignment = .center
        self.view.addSubview(noInternetLabel)
        noInternetLabel.snp.makeConstraints { (m) in
            m.right.bottom.left.equalToSuperview()
            m.height.equalTo(40)
        }
        
        UIView.animate(withDuration: 1, delay: 1, options: [.curveEaseOut], animations: {
            noInternetLabel.alpha = 0
        }, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
            noInternetLabel.removeFromSuperview()
        }
    }
//    
//    func checkError(error: ServiceError) {
//        switch error {
//        case .noInternetConnection:
//            noInternetConnection()
//            break
//        case .notFound:
//            break
//        case .unauthorized:
//            break
//        }
//    }
//    
//    func setNoInternetConnectionLabel() {
//        
//    }
}
