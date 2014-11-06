//
//  Region.swift
//  flugwecker
//
//  Created by Udo von Eynern on 11.08.14.
//  Copyright (c) 2014 Udo von Eynern. All rights reserved.
//

import Foundation

class Region : PFObject, PFSubclassing {
    
    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var airportsList: [Airport]
    @NSManaged var counter: Int

    class func parseClassName() -> String! {
        return "Region"
    }
}