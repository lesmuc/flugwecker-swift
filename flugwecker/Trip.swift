//
//  Trip.swift
//  flugwecker
//
//  Created by Udo von Eynern on 24.08.14.
//  Copyright (c) 2014 Udo von Eynern. All rights reserved.
//

import Foundation

struct Trip {
    let id : String!
    let startDate : String!
    let endDate : String!
    let name : String!
    let updatedAt : String!
    let origins : [Airport]
    let destinations : [Airport]
    let regions : [Region]

    static func decode(json: JSONValue) -> Trip {
        
        var id = json["id"].string as String!
        var startDate = json["startDate"].string as String!
        var endDate = json["endDate"].string as String!
        var name = json["name"].string as String!
        var updatedAt = json["updatedAt"].string as String!

        var jsonOriginsArray = json["origins"].array as Array!
        var jsonDestinationsArray = json["destinations"].array as Array!
        var jsonRegionsArray = json["regions"].array as Array!
        
        var origins = [Airport]()
        var destinations = [Airport]()
        var regions = [Region]()
        
        for jsonOrigin in jsonOriginsArray {
            origins.append(
                Airport(
                    id: jsonOrigin["id"].string as String!,
                    name: jsonOrigin["name"].string as String!,
                    image: jsonOrigin["image"].string as String!,
                    city: jsonOrigin["city"].string as String!,
                    counterFlights: jsonOrigin["counterFlights"].integer as Int!
                )
            )
        }
        
        for jsonDestination in jsonDestinationsArray {
            destinations.append(
                Airport(
                    id: jsonDestination["id"].string as String!,
                    name: jsonDestination["name"].string as String!,
                    image: jsonDestination["image"].string as String!,
                    city: jsonDestination["city"].string as String!,
                    counterFlights: jsonDestination["counterFlights"].integer as Int!
                )
            )
        }
        
        for jsonRegion in jsonRegionsArray {
            regions.append(
                Region(
                    id: jsonRegion["id"].string as String!,
                    name: jsonRegion["name"].string as String!,
                    maxPrice: jsonRegion["maxPrice"].double as Double!
                )
            )
        }
        
        return Trip(id: id, startDate: startDate, endDate: endDate, name: name, updatedAt: updatedAt, origins: origins, destinations: destinations, regions: regions)
    }
}
