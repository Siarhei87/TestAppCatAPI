//
//  ImageExtensions.swift
//  TestAppCatAPI
//
//  Created by Dubko Siarhei on 30.08.23.
//

import Foundation
import UIKit

extension UIImageView {
    private enum Cache {
        static let image = NSCache<AnyObject, AnyObject>()
    }
    
    func setImageFromURL(_ urlString: String) {
        self.image = nil
        
        if let cachedImage = Cache.image.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
    
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, _, error in
                if error != nil {
                    print(error!)
                    return
                }
                
                DispatchQueue.main.async {
                    if let image = UIImage(data: data!) {
                        Cache.image.setObject(image, forKey: urlString as AnyObject)
                        self.image = image
                    }
                }
            }
            .resume()
        }
    }
}
