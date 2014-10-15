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
    
    static func decode(json: JSON) -> Flight {
        
        var price = json["price"].doubleValue as Double!
        var departureDate = json["departureDate"].stringValue as String!
        var returnDate = json["returnDate"].stringValue as String!
        var url = json["url"].stringValue as String!
        var service = json["service"].stringValue as String!
        
        return Flight(price: price, departureDate: departureDate, returnDate: returnDate, url: url, service: service)
    }
}
