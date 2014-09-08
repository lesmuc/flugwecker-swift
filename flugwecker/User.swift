//
//  User.swift
//  flugwecker
//
//  Created by Udo von Eynern on 24.08.14.
//  Copyright (c) 2014 Udo von Eynern. All rights reserved.
//

import Foundation

struct User {
    var id : Int!
    var username : String!
    var email : String!
    var password : String!
    
    static func decode(json: JSONValue) -> User {
        
        var id = json["user_id"].number as Int!
        var username = json["username"].string as String!
        var email = json["email"].string as String!
        var password = json["password"].string as String!
        
        return User(id: id, username: username, email: email, password: password);
    }
    
    func toDictionary() -> NSMutableDictionary {
        
        var properties = NSMutableDictionary()
        
        if self.id != nil {
            properties["user_id"] = self.id
        }

        if self.username != nil {
            properties["username"] = self.username
        }
        
        if self.email != nil {
            properties["email"] = self.email
        }
        
        if self.password != nil {
            properties["password"] = self.password
        }
        
        return properties
    }
}
