//
//  Post.swift
//  InstaPost2
//
//  Created by Tri Dang on 11/12/19.
//  Copyright © 2019 Tri Dang. All rights reserved.
//

import Foundation
import UIKit

struct Post {
    var id:Int = -1
    var username:String = ""
    var image:Int = -2
    var imageBase64:String = ""
    var rating:Double?
    var ratingCount:Int = -1
    var ratingImage:String {
        get {
            switch rating {
            case -1:
                return "stars_0"
            case 1:
                return "stars_1"
            case 1.5:
                return "stars_1_half"
            case 2:
                return "stars_2"
            case 2.5:
               return "stars_2_half"
            case 3:
                return "stars_3"
            case 3.5:
                return "stars_3_half"
            case 4:
                return "stars_4"
            case 4.5:
                return "stars_4_half"
            case 5:
                return "stars_5"
            default:
                return ""
            }
        }
    }
    var text:String = ""
    var hashtags = [String]()
    var comments = [String]()
}
