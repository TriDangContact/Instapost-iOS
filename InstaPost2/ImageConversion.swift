//
//  ImageExtension.swift
//  InstaPost2
//
//  Created by Tri Dang on 11/13/19.
//  Copyright © 2019 Tri Dang. All rights reserved.
//

import Foundation
import UIKit

struct ImageConversion {
    func ToBase64String(img: UIImage) -> String {
//        return img.pngData()?.base64EncodedString(options: .lineLength64Characters) ?? ""
        
        //method 2
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
    
    func ToImage(imageBase64String:String) -> UIImage {
        if !imageBase64String.isEmpty {
            if let imageData = Data.init(base64Encoded: imageBase64String, options: .init(rawValue: 0)) {
                if let image = UIImage(data: imageData) {
                    return image
                }
            }
        }
        return UIImage(named: "no_image_error") ?? UIImage()
            //method 2
//            let imageData = Data.init(base64Encoded: imageBase64String, options: .init(rawValue: 0))
//            let image = UIImage(data: imageData!)
//            return image
            
            //method 3
//            let dataDecoded:NSData = NSData(base64Encoded: imageBase64String, options: NSData.Base64DecodingOptions(rawValue: 0))!
//            let decodedimage:UIImage = UIImage(data: dataDecoded as Data)!
//            return decodedimage
    }
}
