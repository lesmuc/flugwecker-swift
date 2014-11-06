//
//  FlightConnection.swift
//  flugwecker
//
//  Created by Udo von Eynern on 13.08.14.
//  Copyright (c) 2014 Udo von Eynern. All rights reserved.
//

import Foundation

class FlightConnection : PFObject, PFSubclassing {
    
    @NSManaged var id: String
    @NSManaged var origin: Airport
    @NSManaged var destination: Airport
    @NSManaged var counter: Int
    @NSManaged var minPrice: Double
    
    class func parseClassName() -> String! {
        return "FlightConnection"
    }
}
