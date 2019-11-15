//
//  InstaPostAPI.swift
//  InstaPost2
//
//  Created by Tri Dang on 11/12/19.
//  Copyright © 2019 Tri Dang. All rights reserved.
//

import Foundation
import Alamofire

class InstaPostAPI {
    
    var testURL = "https://bismarck.sdsu.edu/api/ping"
    var nicknamesURL = "https://bismarck.sdsu.edu/api/instapost-query/nicknames"
    var nicknamesExistURL = "https://bismarck.sdsu.edu/api/instapost-query/nickname-exists"
    var authenticateURL = "https://bismarck.sdsu.edu/api/instapost-query/authenticate"
    var newUserURL = "https://bismarck.sdsu.edu/api/instapost-upload/newuser"
    var hashtagsURL = "https://bismarck.sdsu.edu/api/instapost-query/hashtags"
    var postFromIdURL = "https://bismarck.sdsu.edu/api/instapost-query/post"
    var imageFromIdURL = "https://bismarck.sdsu.edu/api/instapost-query/image"
    var uploadPostURL = "https://bismarck.sdsu.edu/api/instapost-upload/post"
    var uploadImageURL = "https://bismarck.sdsu.edu/api/instapost-upload/image"
    var uploadCommentURL = "https://bismarck.sdsu.edu/api/instapost-upload/comment"
    var uploadRatingURL = "https://bismarck.sdsu.edu/api/instapost-upload/rating"
    
    var nicknamePostsURL = "https://bismarck.sdsu.edu/api/instapost-query/nickname-post-ids"
    var hashtagPostsURL = "https://bismarck.sdsu.edu/api/instapost-query/hashtags-post-ids"
    
    
    func getAuthenticationParameters(email:String, password:String) -> Parameters {
        return ["email":email, "password":password]
    }
    
    func getNicknameExistsParameters(nickname:String) -> Parameters {
        return ["nickname":nickname]
    }
    
    func getNewUserParameters(first:String, last:String, nickname:String, email:String, pw:String) -> Parameters {
        return ["firstname":first,
                "lastname":last,
                "nickname":nickname,
                "email":email,
                "password":pw]
    }
    
    func getNicknamePostsParameters(nickname:String) -> Parameters {
        return ["nickname":nickname]
    }
    
    func getHashtagPostsParameters(hashtag:String) -> Parameters {
        return ["hashtag":hashtag]
    }
    
    func getPostFromIdParameters(postID:Int) -> Parameters {
        return ["post-id":postID]
    }
    
    func getImageFromIdParameters(imageID:Int) -> Parameters {
        return ["id":imageID]
    }
    
    func getUploadPostParameters(email:String, pw:String, text:String, tags:[String]) -> Parameters {
        return ["email":email, "password":pw, "text":text, "hashtags": tags]
    }
    
    func getUploadImageParameters(email:String, pw:String, image:String, postID:Int) -> Parameters {
        return ["email":email, "password":pw, "image":image, "post-id": postID]
    }
    
    func getUploadCommentParameters(email:String, pw:String, comment:String, postID:Int) -> Parameters {
        return ["email":email, "password":pw, "comment":comment, "post-id": postID]
    }
    
    func getUploadRatingParameters(email:String, pw:String, rating:Int, postID:Int) -> Parameters {
        return ["email":email, "password":pw, "rating":rating, "post-id": postID]
    }
    
    func convertANYtoSTRING(data: Any, key:String) -> String {
        var result = ""
        let jsonDict:NSDictionary = data as! NSDictionary
        if let value = jsonDict.value(forKey: key) {
            result = value as! String
        }
        return result
    }
    
    func convertANYtoINT(data: Any, key:String) -> Int {
        var result = -1
        let jsonDict:NSDictionary = data as! NSDictionary
        if let value = jsonDict.value(forKey: key) {
            result = value as! Int
        }
        return result
    }
    
    // TODO: need to implement
    func convertANYtoPOST(data: Any, key: String) -> Post {
        var post = Post()
        let jsonDict:NSDictionary = data as! NSDictionary
        // grab the post object from our result
        if let postANYObj = jsonDict.value(forKey: key) {
            // need to convert post ANY object into Dict object
            let postDict:NSDictionary = postANYObj as! NSDictionary
            if let comments = postDict.value(forKey: "comments") {
                post.comments = comments as! [String]
            }
            if let ratingsCount = postDict.value(forKey: "ratings-count") {
                post.ratingCount = ratingsCount as! Int
            }
            // ratings retrieved from server needs to conform to our standard
            if let ratings = postDict.value(forKey: "ratings-average") {
                let ratingDOUBLE = ratings as! Double
                let rounded = Double(ratingDOUBLE).roundHalf()
                post.rating = rounded
            }
            if let id = postDict.value(forKey: "id") {
                post.id = id as! Int
            }
            if let hashtags = postDict.value(forKey: "hashtags") {
                post.hashtags = hashtags as! [String]
            }
            if let image = postDict.value(forKey: "image") {
                post.image = image as! Int
            }
            if let text = postDict.value(forKey: "text") {
                post.text = text as! String
            }
        }
        
        return post
    }
    
    // helper methods to convert AnyObject? from AF requests
    func convertANYtoSTRINGArray(data: Any, key:String) -> [String] {
        var result = [String]()
        let jsonDict:NSDictionary = data as! NSDictionary
        if let value = jsonDict.value(forKey: key) {
            let valueArray = value as! Array<String>
            result = valueArray
        }
        return result
    }
    
    func convertANYtoINTArray(data: Any, key:String) -> [Int] {
        var result = [Int]()
        let jsonDict:NSDictionary = data as! NSDictionary
        if let value = jsonDict.value(forKey: key) {
            let valueArray = value as! Array<Int>
            result = valueArray
        }
        return result
    }
    
    
    
//    METHODS TO TEST SERVER REQUESTS
    func test(){
         AF.request(testURL)
             .responseJSON { response in
                 switch response.result {
                     case .success(let result):
                         print(self.convertANYtoSTRING(data: result, key: "message"))
                     case .failure(let error):
                         print(error.errorDescription ?? "Server Error")
                 }
             }
     }
     
     func getAllNicknames(){
         AF.request(nicknamesURL)
             .validate()
             .responseJSON { response in
                 switch response.result {
                     case .success(let result):
                         print(self.convertANYtoSTRINGArray(data: result, key: "nicknames"))
                     case .failure(let error):
                         print(error.errorDescription ?? "Server Error: cannot retrieve nicknames")
                 }
             }
     }
    
    func getAllHashtags(){
        AF.request(hashtagsURL)
            .validate()
            .responseJSON { response in
                switch response.result {
                    case .success(let result):
                        print(self.convertANYtoSTRINGArray(data: result, key: "hashtags"))
                    case .failure(let error):
                        print(error.errorDescription ?? "Server Error: cannot retrieve nicknames")
                }
            }
    }
    
    
    
}

// helper to round ratings
extension Double {
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    func roundHalf() -> Double {
        switch self {
        case 1..<1.25:
            return 1
        case 1.25..<1.5:
            return 1.5
        case 1.5..<1.75:
            return 1.5
        case 1.75..<2:
            return 2
            
        case 2..<2.25:
            return 2
        case 2.25..<2.5:
            return 2.5
        case 2.5..<2.75:
            return 2.5
        case 2.75..<3:
            return 3
            
        case 3..<3.25:
            return 3
        case 3.25..<3.5:
            return 3.5
        case 3.5..<3.75:
            return 3.5
        case 3.75..<4:
            return 4
            
        case 4..<4.25:
            return 4
        case 4.25..<4.5:
            return 4.5
        case 4.5..<4.75:
            return 4.5
        case 4.75..<5:
            return 5
            
        case 5:
            return 5
        default:
            return -1
        }
    }
}
