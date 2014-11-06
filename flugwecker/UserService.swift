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
}