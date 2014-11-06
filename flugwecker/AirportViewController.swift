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
    
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        let color = UIColor(red: 4/255, green: 153/255, blue: 153/255, alpha: 1.0)
        
        if let font = UIFont(name: "Copperplate-Light", size: 16.0) {
            
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: font,
                NSForegroundColorAttributeName: color]
        }
        
        self.navigationController?.navigationBar.tintColor = UIColor(red: 4/255, green: 153/255, blue: 153/255, alpha: 1.0)
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
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        var findAirports:PFQuery = Airport.query()
        findAirports.whereKey("country", equalTo: "DE")
        findAirports.whereKey("originCounter", greaterThan: 0)
        
        findAirports.findObjectsInBackgroundWithBlock { (objects:[AnyObject]!, error:NSError!) -> Void in
            if !(error != nil) {
                
                self.items.removeAll(keepCapacity: true)
                
                for airport in objects as [Airport] {
                    self.items.append(airport as Airport)
                }
                
                self.tableView.reloadData()
                
                if self.refreshControl.refreshing == true {
                    self.refreshControl.endRefreshing()
                }
                
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                
            } else {
                
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                
                let alertTitle = NSLocalizedString("Error", comment: "")
                let okayString = NSLocalizedString("OK", comment: "")
                
                let alert = UIAlertView()
                alert.title = alertTitle
                alert.message = error.localizedDescription
                
                alert.addButtonWithTitle(okayString)
                alert.show()
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let controller = segue.destinationViewController as FlightConnectionViewController
        
        var selectedIndexPathRow:Int = self.tableView.indexPathForSelectedRow()?.row as Int!

        let airport = self.items[selectedIndexPathRow]
        
        controller.selectedAirport = airport;
    }
}


