//
//  Region.swift
//  flugwecker
//
//  Created by Udo von Eynern on 11.08.14.
//  Copyright (c) 2014 Udo von Eynern. All rights reserved.
//

import Foundation

struct Region {
    let id : String!
    let name : String!
    let maxPrice : Double!
    
    static func decode(json: JSONValue) -> Region {
        
        var id = json["code"].string as String!
        var name = json["name"].string as String!
        var maxPrice = json["maxprice"].double as Double!
        
        return Region(id: id, name: name, maxPrice: maxPrice)
    }
}
