//
//  MasterViewController.swift
//  flugwecker
//
//  Created by Udo von Eynern on 08.08.14.
//  Copyright (c) 2014 Udo von Eynern. All rights reserved.
//

import UIKit

class AirportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let API_URL = "http://www.flugwecker.de"    
    
    var items = [Airport]()
    
    @IBOutlet var tableView : UITableView!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
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
        self.activityIndicatorView.startAnimating()
        
        Alamofire.Manager.sharedInstance.defaultHeaders["Accept"] = "application/json"
        
        Alamofire.request(.GET, "\(API_URL)/airports-inside/de", parameters: nil).response {request, response, data, error in
            let json = JSONValue(data as NSData)
            
            if json["airports"] {
                
                self.items.removeAll(keepCapacity: true)
                
                for jsonAirport in json["airports"].array!{
                    let airport = Airport.decode(jsonAirport)
                    self.items.append(airport)
                }
            }
            
            self.tableView.reloadData()
            
            if self.refreshControl.refreshing == true {
                self.refreshControl.endRefreshing()
            }
            
            self.activityIndicatorView.stopAnimating()
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


