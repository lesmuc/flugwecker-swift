//
//  RegionViewController.swift
//  flugwecker
//
//  Created by Udo von Eynern on 11.08.14.
//  Copyright (c) 2014 Udo von Eynern. All rights reserved.
//

import UIKit

class RegionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let API_URL = "http://www.flugwecker.de"
    
    var items = [Region]()
    
    var airport: Airport!
    
    @IBOutlet var tableView : UITableView!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.loadItems()
    }
    
    func refresh(sender:AnyObject) {
        self.loadItems()
    }
    
    func loadItems() {
        self.activityIndicatorView.startAnimating()
        
        Alamofire.Manager.sharedInstance.defaultHeaders["Accept"] = "application/json"
        
        let origin:String = airport.id
        
        Alamofire.request(.GET, "\(API_URL)/regions-from/\(airport.id)", parameters: nil).response {request, response, data, error in
            
            let json = JSONValue(data as NSData)
            
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
            
            self.activityIndicatorView.stopAnimating()
        }
    }
    
    // MARK: - Table View
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count > 0 ? self.items.count + 1 : 0
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        if indexPath.row == 0 {
            return 200
        } else {
            return 44.0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("CellHeader", forIndexPath: indexPath) as UITableViewCell
            
            let imageView = cell.viewWithTag(300) as UIImageView
            
            let url = "\(API_URL)/image.php?src=img/airports/shutterstock_\(self.airport.image).jpg&w=\(cell.frame.size.width)&h=200"
            
            println(url)
            
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
            
            cell.textLabel.text = region.name
            
            return cell
        }
    }
}
