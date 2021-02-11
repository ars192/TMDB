//
//  UIImageView+Extension.swift
//  TMDB
//
//  Created by Arystan on 2/10/21.
//

import Foundation
import UIKit
import Alamofire

let imageCache = NSCache<AnyObject, AnyObject>()
class CustomImageView: UIImageView {
    var imageUrlString: String?
    func loadImageFromUrl(urlString: String) {
        imageUrlString = urlString
        guard let url = URL(string: urlString) else { return }
        image = nil
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        AF.request(url)
            .validate()
            .responseJSON { (response) in
                DispatchQueue.main.async {
                    guard let data = response.data else { return }
                    let imageToCache = UIImage(data: data)
                    print("Getting image")
                    if self.imageUrlString == urlString {
                        self.image = imageToCache
                    }
                    if let imageToCache = imageToCache {
                        imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                    }
                }
        }
    }
}
