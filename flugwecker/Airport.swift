//
//  Airport.swift
//  flugwecker
//
//  Created by Udo von Eynern on 11.08.14.
//  Copyright (c) 2014 Udo von Eynern. All rights reserved.
//

import Foundation

class Airport : PFObject, PFSubclassing {
    
    @NSManaged var id: String
    @NSManaged var code: String
    @NSManaged var name: String
    @NSManaged var image: String
    @NSManaged var city: String
    @NSManaged var counterFlights: Int
    
    class func parseClassName() -> String! {
        return "Airport"
    }
}
