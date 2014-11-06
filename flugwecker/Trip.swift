//
//  Trip.swift
//  flugwecker
//
//  Created by Udo von Eynern on 24.08.14.
//  Copyright (c) 2014 Udo von Eynern. All rights reserved.
//

import Foundation

class Trip : PFObject, PFSubclassing {
    
    @NSManaged var id: String
    @NSManaged var startDate: String
    @NSManaged var endDate: String
    @NSManaged var name: String
    @NSManaged var updated: String
    
    class func parseClassName() -> String! {
        return "Trip"
    }
}

/*

struct Trip {
    let id : String!
    let startDate : String!
    let endDate : String!
    let name : String!
    let updatedAt : String!
    let origins : [Airport]
    let destinations : [Airport]
    let regions : [Region]

    static func decode(json: JSON) -> Trip {
        
        var id = json["id"].stringValue as String!
        var startDate = json["startDate"].stringValue as String!
        var endDate = json["endDate"].stringValue as String!
        var name = json["name"].stringValue as String!
        var updatedAt = json["updatedAt"].stringValue as String!

        var jsonOriginsArray = json["origins"].arrayValue as Array!
        var jsonDestinationsArray = json["destinations"].arrayValue as Array!
        var jsonRegionsArray = json["regions"].arrayValue as Array!
        
        var origins = [Airport]()
        var destinations = [Airport]()
        var regions = [Region]()
        
        for jsonOrigin in jsonOriginsArray {
            origins.append(
                Airport(
                    id: jsonOrigin["id"].stringValue as String!,
                    name: jsonOrigin["name"].stringValue as String!,
                    image: jsonOrigin["image"].stringValue as String!,
                    city: jsonOrigin["city"].stringValue as String!,
                    counterFlights: jsonOrigin["counterFlights"].intValue as Int!
                )
            )
        }
        
        for jsonDestination in jsonDestinationsArray {
            destinations.append(
                Airport(
                    id: jsonDestination["id"].stringValue as String!,
                    name: jsonDestination["name"].stringValue as String!,
                    image: jsonDestination["image"].stringValue as String!,
                    city: jsonDestination["city"].stringValue as String!,
                    counterFlights: jsonDestination["counterFlights"].intValue as Int!
                )
            )
        }
        
        for jsonRegion in jsonRegionsArray {
            regions.append(
                Region(
                    id: jsonRegion["id"].stringValue as String!,
                    name: jsonRegion["name"].stringValue as String!,
                    maxPrice: jsonRegion["maxPrice"].doubleValue as Double!
                )
            )
        }
        
        return Trip(id: id, startDate: startDate, endDate: endDate, name: name, updatedAt: updatedAt, origins: origins, destinations: destinations, regions: regions)
    }
}
*/
