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
    func ToBase64String (img: UIImage) -> String {
        return img.pngData()?.base64EncodedString(options: .lineLength64Characters) ?? ""
    }
    
    func ToImage (imageBase64String:String) -> UIImage {
        let imageData = Data.init(base64Encoded: imageBase64String, options: .init(rawValue: 0))
        let image = UIImage(data: imageData!)
        return image!
    }
}
