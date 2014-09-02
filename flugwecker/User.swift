//
//  User.swift
//  flugwecker
//
//  Created by Udo von Eynern on 24.08.14.
//  Copyright (c) 2014 Udo von Eynern. All rights reserved.
//

import Foundation

struct User {
    let id : String!
    let username : String!
    let email : String!
    let password : String!
    
    let facebookId : String?
    let foursquareId : String?
    
    let imagePath : String?
    
    static func decode(json: JSONValue) -> User {
        
        var id = json["user_id"].string as String!
        var username = json["username"].string as String!
        var email = json["email"].string as String!
        var password = json["password"].string as String!
        
        var facebookId = json["facebookId"].string as String?
        var foursquareId = json["foursquareId"].string as String?

        var imagePath = json["imagePath"].string as String?
        
        return User(id: id, username: username, email: email, password: password, facebookId: facebookId, foursquareId: foursquareId, imagePath: imagePath);
    }
}
