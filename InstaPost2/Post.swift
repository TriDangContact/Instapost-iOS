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
    var id:Int?
    var username:String?
    var image:String?
    var rating:Int?
    var ratingImage:String {
        get {
            switch rating {
            case 1:
                return "stars_1"
            case 2:
                return "stars_2"
            case 3:
                return "stars_3"
            case 4:
                return "stars_4"
            case 5:
                return "stars_5"
            default:
                return ""
            }
        }
    }
    var caption:String?
    var tag:String?
}
