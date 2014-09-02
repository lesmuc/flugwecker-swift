//
//  Flight.swift
//  flugwecker
//
//  Created by Udo von Eynern on 13.08.14.
//  Copyright (c) 2014 Udo von Eynern. All rights reserved.
//

import Foundation

struct Flight {
    let price : Double!
    let departureDate : String!
    let returnDate : String!
    let url : String!
    let service : String!
    
    static func decode(json: JSONValue) -> Flight {
        
        var price = json["price"].double as Double!
        var departureDate = json["departureDate"].string as String!
        var returnDate = json["returnDate"].string as String!
        var url = json["url"].string as String!
        var service = json["service"].string as String!
        
        return Flight(price: price, departureDate: departureDate, returnDate: returnDate, url: url, service: service)
    }
}
