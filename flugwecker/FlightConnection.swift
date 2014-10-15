//
//  FlightConnection.swift
//  flugwecker
//
//  Created by Udo von Eynern on 13.08.14.
//  Copyright (c) 2014 Udo von Eynern. All rights reserved.
//

import Foundation

struct FlightConnection {
    
    let origin : Airport!
    let destination : Airport!
    let flights : [Flight]
    let minPrice: Double!
    
    static func decode(json: JSON) -> FlightConnection {
        
        var origin = Airport(id: json["origin"].stringValue as String!, name: json["originName"].stringValue as String!, image: json["originImage"].stringValue as String!, city: nil, counterFlights: nil)
        var destination = Airport(id: json["destination"].stringValue as String!, name: json["destinationName"].stringValue as String!, image: json["destinationImage"].stringValue as String!, city: nil, counterFlights: nil)
        
        var jsonFlightsArray = json["flights"].arrayValue as Array!
        
        var flights = [Flight]()
        
        var minPrice = 0.0
        
        for jsonFlight in jsonFlightsArray {
            flights.append(
                Flight(
                    price: jsonFlight["price"].doubleValue as Double!,
                    departureDate: jsonFlight["departureDate"].stringValue as String!,
                    returnDate: jsonFlight["returnDate"].stringValue as String!,
                    url: jsonFlight["url"].stringValue as String!,
                    service: jsonFlight["service"].stringValue as String!
                )
            )
            
            if (minPrice == 0.0 || minPrice > jsonFlight["price"].doubleValue as Double!) {
                minPrice = jsonFlight["price"].doubleValue as Double!
            }
        }

        return FlightConnection(origin: origin, destination: destination, flights: flights, minPrice: minPrice)
    }
}
