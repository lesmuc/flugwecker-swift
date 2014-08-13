//
//  MasterViewController.swift
//  flugwecker
//
//  Created by Udo von Eynern on 08.08.14.
//  Copyright (c) 2014 Udo von Eynern. All rights reserved.
//

import UIKit

class AirportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var items = [Airport]()
    
    @IBOutlet var tableView : UITableView!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)

        if self.items.count == 0 {
            
            self.activityIndicatorView.startAnimating()
            
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
                
                self.activityIndicatorView.stopAnimating()
            }
        }
    }

    // MARK: - Table View
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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


