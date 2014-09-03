//
//  RegionViewController.swift
//  flugwecker
//
//  Created by Udo von Eynern on 11.08.14.
//  Copyright (c) 2014 Udo von Eynern. All rights reserved.
//

import UIKit

import Alamofire

class RegionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var items = [Region]()

    let headerImageWidth:CGFloat = UIDevice.currentDevice().userInterfaceIdiom == .Phone ? 568.0 : 1024.0
    let headerImageHeight:CGFloat = UIDevice.currentDevice().userInterfaceIdiom == .Phone ? 200.0 : 400.0
    
    var selectedAirport: Airport!
    
    @IBOutlet var tableView : UITableView!
    
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        self.title = "Ziel / Region"
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.loadItems()
    }
    
    func refresh(sender:AnyObject) {
        self.loadItems()
    }
    
    func loadItems() {
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)        
        
        Alamofire.Manager.sharedInstance.defaultHeaders["Accept"] = "application/json"
        
        let origin:String = selectedAirport.id
        
        Alamofire.request(.GET, "\(API_URL)/regions-from/\(selectedAirport.id)", parameters: nil).response {request, response, data, error in
            
            let json = JSONValue(data as NSData!)
            
            if json["regions"] {
                
                self.items.removeAll(keepCapacity: true)
                
                for jsonRegion in json["regions"].array!{
                    let region = Region.decode(jsonRegion)
                    
                    self.items.append(region)
                }
            }
            
            self.tableView.reloadData()
            
            if self.refreshControl.refreshing == true {
                self.refreshControl.endRefreshing()
            }
            
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)            
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
            
            let url = "\(API_URL)/image.php?src=img/airports/shutterstock_\(self.selectedAirport.image).jpg&w=\(self.headerImageWidth)&h=\(self.headerImageHeight)"
            
            var imageRequest: NSURLRequest = NSURLRequest(URL: NSURL(string: url))
            
            NSURLConnection.sendAsynchronousRequest(imageRequest,
                queue: NSOperationQueue.mainQueue(),
                completionHandler:{response, data, error in
                    imageView.image = UIImage(data: data)
            })
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("RegionIdentifier", forIndexPath: indexPath) as UITableViewCell
            
            let region: Region = self.items[indexPath.row-1]
            
            cell.textLabel?.text = region.name
            
            return cell
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let controller = segue.destinationViewController as FlightConnectionViewController
        
        var selectedIndexPathRow:Int = self.tableView.indexPathForSelectedRow()?.row as Int!
        
        let region = self.items[selectedIndexPathRow-1] as Region
        
        controller.selectedAirport = selectedAirport;
        controller.selectedRegion = region
    }
}
