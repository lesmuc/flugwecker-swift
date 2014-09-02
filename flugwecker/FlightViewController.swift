//
//  FlightViewController.swift
//  flugwecker
//
//  Created by Udo von Eynern on 14.08.14.
//  Copyright (c) 2014 Udo von Eynern. All rights reserved.
//

import UIKit

class FlightViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let headerImageWidth:CGFloat = UIDevice.currentDevice().userInterfaceIdiom == .Phone ? 568.0 : 1024.0
    let headerImageHeight:CGFloat = UIDevice.currentDevice().userInterfaceIdiom == .Phone ? 200.0 : 400.0
    
    var selectedAirport: Airport!
    var selectedRegion: Region!
    var selectedFlightConnection: FlightConnection!
    
    @IBOutlet var tableView : UITableView!
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.title =  self.selectedFlightConnection.destination.name
    }
    
    // MARK: - Table View
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedFlightConnection.flights.count > 0 ? self.selectedFlightConnection.flights.count + 1 : 0
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
            
            var imageRequest: NSURLRequest = NSURLRequest(URL: NSURL(string: url))
            
            NSURLConnection.sendAsynchronousRequest(imageRequest,
                queue: NSOperationQueue.mainQueue(),
                completionHandler:{response, data, error in
                    imageView.image = UIImage(data: data)
            })
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("FlightConnectionIdentifier", forIndexPath: indexPath) as UITableViewCell
            
            let flight: Flight = self.selectedFlightConnection.flights[indexPath.row-1]
            
            cell.detailTextLabel.text = String(format:"%.0f", flight.price) + " €"
            
            var inputFormatter : NSDateFormatter = NSDateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let departureDate = inputFormatter.dateFromString(flight.departureDate) as NSDate!
            let returnDate = inputFormatter.dateFromString(flight.returnDate) as NSDate!
            
            var outputFormatter : NSDateFormatter = NSDateFormatter()
            outputFormatter.dateFormat = "EEEE dd.MM.yyyy"

            cell.textLabel.text = outputFormatter.stringFromDate(departureDate) + " - " + outputFormatter.stringFromDate(returnDate)

            return cell
        }
    }
    
    func tableView(tableView: UITableView!, didDeselectRowAtIndexPath indexPath: NSIndexPath!) {
        
        let flight: Flight = self.selectedFlightConnection.flights[indexPath.row-1]
        
        UIApplication.sharedApplication().openURL(NSURL.URLWithString(flight.url))
    }
}
