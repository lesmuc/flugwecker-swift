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
    
    let city : String?
    let counterFlights : Int?

    static func decode(json: JSON) -> Airport {
        
        var id = json["id"].stringValue as String!
        var name = json["name"].stringValue as String!
        var image = json["image"].stringValue as String!
        
        var city = json["city"].stringValue as String?
        var counterFlights = json["counterFlights"].intValue as Int?
        
        return Airport(id: id, name: name, image: image, city: city, counterFlights:counterFlights)
    }
}
