//
//  RegionViewController.swift
//  flugwecker
//
//  Created by Udo von Eynern on 11.08.14.
//  Copyright (c) 2014 Udo von Eynern. All rights reserved.
//

import UIKit

class RegionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var items = [Region]()
    
    var airport: Airport!
    
    @IBOutlet var tableView : UITableView!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.activityIndicatorView.startAnimating()

        Alamofire.Manager.sharedInstance.defaultHeaders["Accept"] = "application/json"
        
        let origin:String = airport.id
        
        Alamofire.request(.GET, "http://www.flugwecker.de/regions-from/" + airport.id, parameters: nil).response {request, response, data, error in
            
            let json = JSONValue(data as NSData)
            
            if json["regions"] {
                for jsonRegion in json["regions"].array!{
                    let region = Region.decode(jsonRegion)
                    
                    self.items.append(region)
                }
            }
            
            self.tableView.reloadData()
            
            self.activityIndicatorView.stopAnimating()
        }
    }
    
    // MARK: - Table View
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RegionIdentifier", forIndexPath: indexPath) as UITableViewCell
        
        let region: Region = self.items[indexPath.row]
        
        cell.textLabel.text = region.name
        
        return cell
    }
}
