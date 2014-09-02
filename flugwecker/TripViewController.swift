//
//  TripViewController.swift
//  flugwecker
//
//  Created by Udo von Eynern on 24.08.14.
//  Copyright (c) 2014 Udo von Eynern. All rights reserved.
//

import UIKit

class TripViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var items = [Trip]()
    
    @IBOutlet var tableView : UITableView!
    
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor(red: 4/255, green: 153/255, blue: 153/255, alpha: 1.0), NSFontAttributeName: UIFont(name: "Copperplate-Light", size: 20.0)]
        
        self.navigationController.navigationBar.titleTextAttributes = titleDict
        self.navigationController.navigationBar.tintColor = UIColor(red: 4/255, green: 153/255, blue: 153/255, alpha: 1.0)
        
        self.title = "Abflug"
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if self.items.count == 0 {
            
            self.loadItems()
        }
    }
    
    func refresh(sender:AnyObject) {
        self.loadItems()
    }
    
    func loadItems() {
        
        /*
        Alamofire.Manager.sharedInstance.defaultHeaders["Accept"] = "application/json"
        
        Alamofire.request(.GET, "\(API_URL)/airports-inside/de", parameters: nil).response {request, response, data, error in
            
            let json = JSONValue(data as NSData!)
            
            if json["airports"] {
                
                self.items.removeAll(keepCapacity: true)
                
                for jsonAirport in json["airports"].array!{
                    let airport = Airport.decode(jsonAirport)
                    
                    if airport.counterFlights > 0 {
                        self.items.append(airport)
                    }
                }
            }
            
            self.tableView.reloadData()
            
            if self.refreshControl.refreshing == true {
                self.refreshControl.endRefreshing()
            }
        }
        */
    }
    
    // MARK: - Table View
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("AirportIdentifier", forIndexPath: indexPath) as UITableViewCell
        
        let trip = self.items[indexPath.row]
        
        let name = trip.name
        
        cell.textLabel.text = name;
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        let controller = segue.destinationViewController as RegionViewController
        
        let trip = self.items[self.tableView.indexPathForSelectedRow().row]
    }
}
