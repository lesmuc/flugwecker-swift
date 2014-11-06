//
//  Flight.swift
//  flugwecker
//
//  Created by Udo von Eynern on 13.08.14.
//  Copyright (c) 2014 Udo von Eynern. All rights reserved.
//

import Foundation

class Flight : PFObject, PFSubclassing {
    
    @NSManaged var price: Double
    @NSManaged var departureDate: String
    @NSManaged var returnDate: String
    @NSManaged var url: String
    @NSManaged var service: String
    @NSManaged var origin: Airport
    @NSManaged var destination: Airport
    
    class func parseClassName() -> String! {
        return "Flight"
    }
}