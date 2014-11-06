//
//  FlightViewController.swift
//  flugwecker
//
//  Created by Udo von Eynern on 14.08.14.
//  Copyright (c) 2014 Udo von Eynern. All rights reserved.
//

import UIKit

class FlightViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var items = [Flight]()
    
    let headerImageWidth:CGFloat = UIDevice.currentDevice().userInterfaceIdiom == .Phone ? 568.0 : 1024.0
    let headerImageHeight:CGFloat = UIDevice.currentDevice().userInterfaceIdiom == .Phone ? 200.0 : 400.0
    
    var selectedFlightConnection: FlightConnection!
    
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
        
        self.title =  self.selectedFlightConnection.destination.name
        
        if self.items.count == 0 {
            self.loadItems()
        }
    }
    
    func refresh(sender:AnyObject) {
        self.loadItems()
    }
    
    func loadItems() {
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        var findFlight:PFQuery = Flight.query()
        findFlight.includeKey("origin")
        findFlight.includeKey("destination")
        findFlight.whereKey("origin", equalTo: self.selectedFlightConnection.origin)
        findFlight.whereKey("destination", equalTo: self.selectedFlightConnection.destination)
        findFlight.orderByAscending("departureDate")
        
        findFlight.findObjectsInBackgroundWithBlock { (objects:[AnyObject]!, error:NSError!) -> Void in
            if !(error != nil) {
                
                self.items.removeAll(keepCapacity: true)
                
                for flight in objects as [Flight] {
                    self.items.append(flight)
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
            return self.headerImageHeight
        } else {
            return 44.0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("CellHeader", forIndexPath: indexPath) as UITableViewCell
            
            
            let imageView = cell.viewWithTag(300) as UIImageView
            
            let url = "\(API_URL)/image.php?src=img/airports/shutterstock_\(self.selectedFlightConnection.destination.image).jpg&w=\(self.headerImageWidth)&h=\(self.headerImageHeight)"
            
            println(url)
            
            var imageRequest: NSURLRequest = NSURLRequest(URL: NSURL(string: url)!)
            
            NSURLConnection.sendAsynchronousRequest(imageRequest,
                queue: NSOperationQueue.mainQueue(),
                completionHandler:{response, data, error in
                    imageView.image = UIImage(data: data)
            })
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("FlightIdentifier", forIndexPath: indexPath) as UITableViewCell
            
            let flight: Flight = self.items[indexPath.row-1]
            

            
            var inputFormatter : NSDateFormatter = NSDateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let departureDate = inputFormatter.dateFromString(flight.departureDate) as NSDate!
            let returnDate = inputFormatter.dateFromString(flight.returnDate) as NSDate!
            
            var outputFormatter : NSDateFormatter = NSDateFormatter()
            outputFormatter.dateFormat = "EEEE dd.MM.yyyy"

            cell.textLabel.text = outputFormatter.stringFromDate(departureDate) + " - " + outputFormatter.stringFromDate(returnDate)
            cell.detailTextLabel?.text = String(format:"%.0f", flight.price) + " €"
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView!, didDeselectRowAtIndexPath indexPath: NSIndexPath!) {
        
        let flight: Flight = self.items[indexPath.row-1]
        
        UIApplication.sharedApplication().openURL(NSURL(string: flight.url)!)
    }
}
