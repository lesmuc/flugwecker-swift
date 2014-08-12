//
//  MasterViewController.swift
//  flugwecker
//
//  Created by Udo von Eynern on 08.08.14.
//  Copyright (c) 2014 Udo von Eynern. All rights reserved.
//

import UIKit

class AirportViewController: UITableViewController {
    
    var items = [Airport]()
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)

        Alamofire.Manager.sharedInstance.defaultHeaders["Accept"] = "application/json"

        Alamofire.request(.GET, "http://flugwecker.de/airports-inside/de", parameters: nil).response {request, response, data, error in
            let json = JSONValue(data as NSData)
            
            if json["airports"] {
                for jsonAirport in json["airports"].array!{
                    let airport = Airport.decode(jsonAirport)
                    self.items.append(airport)
                }
            }
            
            self.tableView.reloadData()
        }
    }

    // MARK: - Table View
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AirportIdentifier", forIndexPath: indexPath) as UITableViewCell

        let airport = self.items[indexPath.row]
        
        let name = airport.name
        
        cell.textLabel.text = name;
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        let controller = segue.destinationViewController as RegionViewController

        let airport = self.items[self.tableView.indexPathForSelectedRow().row]
        
        controller.airport = airport;
    }
}


