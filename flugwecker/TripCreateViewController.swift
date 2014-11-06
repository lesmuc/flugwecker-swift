//
//  TripCreateViewController.swift
//  flugwecker
//
//  Created by Udo von Eynern on 01.11.14.
//  Copyright (c) 2014 Udo von Eynern. All rights reserved.
//

import UIKit

class TripCreateViewController: UITableViewController, AirportSelectionProtocol, RegionSelectionProtocol {
 
    var origins = [Airport]()
    
    var destinations = [Airport]()
    
    var currentSegueIdentifier:String = ""
    
    func didSelectAirports(items: Array<Airport>) {
        
        if self.currentSegueIdentifier == "showOriginSelection" {
            self.origins = items
        } else if self.currentSegueIdentifier == "showDestinationSelection" {
            self.destinations = items
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.origins.count > 0 {
            var originCell:UITableViewCell! = self.tableView?.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
            
            var airportCodes = [String]()
            for airport:Airport in self.origins {
                airportCodes.append(airport.code)
            }
            
            originCell.detailTextLabel?.text = join(", ", airportCodes)
        }

        if self.destinations.count > 0 {
            var destinationCell:UITableViewCell! = self.tableView?.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0))
            
            var airportCodes = [String]()
            for airport:Airport in self.destinations {
                airportCodes.append(airport.code)
            }
            
            destinationCell.detailTextLabel?.text = join(", ", airportCodes)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        

        
        self.currentSegueIdentifier = segue.identifier!
        
        if segue.identifier == "showOriginSelection" {
            
            let controller = segue.destinationViewController as AirportSelectionViewController
            
            controller.delegate = self
            controller.selectedItems = self.origins
            
            controller.filteredByCountry = "DE"
        } else if segue.identifier == "showDestinationSelection" {
            
            let controller = segue.destinationViewController as RegionSelectionViewController
            controller.selectedItems = self.destinations
            
            controller.delegate = self

        }
    }

}