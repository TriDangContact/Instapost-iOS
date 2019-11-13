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
    var newUserURL = "https://bismarck.sdsu.edu/api/instapost-upload/newuser"
    var hashtagsURL = "https://bismarck.sdsu.edu/api/instapost-query/hashtags"
    
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
    
    func convertANYtoString(data: Any, key:String) -> String {
        var result = ""
        let jsonDict:NSDictionary = data as! NSDictionary
        if let value = jsonDict.value(forKey: key) {
            result = value as! String
        }
        return result
    }
    
    // helper methods to convert AnyObject? from AF requests
    func convertANYtoArray(data: Any, key:String) -> [String] {
        var result = [String]()
        let jsonDict:NSDictionary = data as! NSDictionary
        if let value = jsonDict.value(forKey: key) {
            let valueArray = value as! Array<String>
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
                         print(self.convertANYtoString(data: result, key: "message"))
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
                         print(self.convertANYtoArray(data: result, key: "nicknames"))
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
                        print(self.convertANYtoArray(data: result, key: "hashtags"))
                    case .failure(let error):
                        print(error.errorDescription ?? "Server Error: cannot retrieve nicknames")
                }
            }
    }
    
    
    
}