//
//  FlightConnectionViewController.swift
//  flugwecker
//
//  Created by Udo von Eynern on 13.08.14.
//  Copyright (c) 2014 Udo von Eynern. All rights reserved.
//

import UIKit

class FlightConnectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var items = [FlightConnection]()
    
    let headerImageWidth:Int = UIDevice.currentDevice().userInterfaceIdiom == .Phone ? 568 : 1024
    let headerImageHeight:Int = UIDevice.currentDevice().userInterfaceIdiom == .Phone ? 200 : 400
    
    var selectedAirport: Airport!
    
    @IBOutlet var tableView : UITableView!
    
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.title = self.selectedAirport.name;
        
        if self.items.count == 0 {
            self.loadItems()
        }
    }
    
    func refresh(sender:AnyObject) {
        self.loadItems()
    }
    
    func loadItems() {
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        var findFlightConnection:PFQuery = FlightConnection.query()
        findFlightConnection.includeKey("origin")
        findFlightConnection.includeKey("destination")
        findFlightConnection.whereKey("origin", equalTo: self.selectedAirport)
        findFlightConnection.whereKey("counter", greaterThan: 0)
        findFlightConnection.orderByAscending("minPrice")
        
        findFlightConnection.findObjectsInBackgroundWithBlock { (objects:[AnyObject]!, error:NSError!) -> Void in
            if !(error != nil) {
                
                self.items.removeAll(keepCapacity: true)
                
                for flightConnection in objects as [FlightConnection] {
                    self.items.append(flightConnection)
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
        return self.items.count > 0 ? self.items.count + 1 : 0
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        if indexPath.row == 0 {
            return CGFloat(self.headerImageHeight)
        } else {
            return 44.0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("CellHeader", forIndexPath: indexPath) as UITableViewCell
            
            let imageView = cell.viewWithTag(300) as UIImageView
            
            let flightConnection: FlightConnection = self.items[0]
            
            let url = "\(API_URL)/image.php?src=img/airports/shutterstock_\(self.selectedAirport.image).jpg&w=\(self.headerImageWidth)&h=\(self.headerImageHeight)"
            
            println(url)
            
            var imageRequest: NSURLRequest = NSURLRequest(URL: NSURL(string: url)!)
            
            NSURLConnection.sendAsynchronousRequest(imageRequest,
                queue: NSOperationQueue.mainQueue(),
                completionHandler:{response, data, error in
                    imageView.image = UIImage(data: data)
            })
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("FlightConnectionIdentifier", forIndexPath: indexPath) as UITableViewCell
            
            let flightConnection: FlightConnection = self.items[indexPath.row-1]
            
            cell.textLabel.text = flightConnection.destination.name
            
            cell.detailTextLabel?.text = "ab " + String(format:"%.0f", flightConnection.minPrice) + " €"
            
            return cell
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {

        let controller = segue.destinationViewController as FlightViewController
        
        var selectedIndexPathRow:Int = self.tableView.indexPathForSelectedRow()?.row as Int!
        
        let flightConnection = self.items[selectedIndexPathRow-1] as FlightConnection
        
        controller.selectedFlightConnection = flightConnection
    }
}
