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

        var keychain:ACSimpleKeychain = ACSimpleKeychain.defaultKeychain() as ACSimpleKeychain
        
        var credentialsFlugwecker = keychain.allCredentialsForService(kUserServiceFlugwecker, limit: 1)
        
        var credentialsFacebook = keychain.allCredentialsForService(kUserServiceFacebook, limit: 1)
        
        if (credentialsFlugwecker != nil) || (credentialsFacebook != nil) {
            return true
        } else {
            return false
        }
    }
}