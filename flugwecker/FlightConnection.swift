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
    
    static func decode(json: JSONValue) -> FlightConnection {
        
        var origin = Airport(id: json["origin"].string as String!, name: json["originName"].string as String!, image: json["originImage"].string as String!, city: nil, counterFlights: nil)
        var destination = Airport(id: json["destination"].string as String!, name: json["destinationName"].string as String!, image: json["destinationImage"].string as String!, city: nil, counterFlights: nil)
        
        var jsonFlightsArray = json["flights"].array as Array!
        
        var flights = [Flight]()
        
        var minPrice = 0.0
        
        for jsonFlight in jsonFlightsArray {
            flights.append(
                Flight(
                    price: jsonFlight["price"].double as Double!,
                    departureDate: jsonFlight["departureDate"].string as String!,
                    returnDate: jsonFlight["returnDate"].string as String!,
                    url: jsonFlight["url"].string as String!,
                    service: jsonFlight["service"].string as String!
                )
            )
            
            if (minPrice == 0.0 || minPrice > jsonFlight["price"].double as Double!) {
                minPrice = jsonFlight["price"].double as Double!
            }
        }

        return FlightConnection(origin: origin, destination: destination, flights: flights, minPrice: minPrice)
    }
}
