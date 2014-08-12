//
//  Airport.swift
//  flugwecker
//
//  Created by Udo von Eynern on 11.08.14.
//  Copyright (c) 2014 Udo von Eynern. All rights reserved.
//

import Foundation

struct Airport {
    let id : String!
    let name : String!
    let image : String!
    let city : String!

    static func decode(json: JSONValue) -> Airport {
        
        var id = json["id"].string as String!
        var name = json["name"].string as String!
        var image = json["image"].string as String!
        var city = json["city"].string as String!
        
        return Airport(id: id, name: name, image: image, city: city)
    }
}
