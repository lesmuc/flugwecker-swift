//
//  UserService.swift
//  flugwecker
//
//  Created by Udo von Eynern on 25.08.14.
//  Copyright (c) 2014 Udo von Eynern. All rights reserved.
//

import Foundation

let kUserServiceFlugwecker:String = "Flugwecker"
let kUserServiceFacebook:String = "Facebook"

class UserService {
    
    class func isUserLoggedIn() -> Bool {

        var user = KeychainService.loadUserJSON()
        
        if (user.isEqual("") == false) {
            return true
        } else {
            return false
        }
    }
    
    class func getAuthentificationRequestSerializer() -> AFJSONRequestSerializer {
        
        var jsonUserString:String = KeychainService.loadUserJSON()
        
        let data = (jsonUserString as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        let json = JSON(data: data as NSData!)
        
        let user = User.decode(json)
        
        let plainString = "\(user.email):\(user.password)" as NSString
        let plainData = plainString.dataUsingEncoding(NSUTF8StringEncoding)
        let base64String = plainData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.fromRaw(0)!)
        
        let requestSerializer = AFJSONRequestSerializer()
        requestSerializer.setValue("Basic " + base64String!, forHTTPHeaderField: "Authorization")
        
        return requestSerializer
        
    }
}