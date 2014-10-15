//
//  TripViewController.swift
//  flugwecker
//
//  Created by Udo von Eynern on 24.08.14.
//  Copyright (c) 2014 Udo von Eynern. All rights reserved.
//

import UIKit
import Alamofire

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
        
        self.navigationController?.navigationBar.titleTextAttributes = titleDict
        self.navigationController?.navigationBar.tintColor = UIColor(red: 4/255, green: 153/255, blue: 153/255, alpha: 1.0)
        
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
        
        if UserService.isUserLoggedIn() == true {
            
            var jsonUserString:String = KeychainService.loadUserJSON()
            
            let data = (jsonUserString as NSString).dataUsingEncoding(NSUTF8StringEncoding)
            let json = JSON(data: data as NSData!)
            let user = User.decode(json)
            
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            
            /*
            Manager.sharedInstance.defaultHeaders["Accept"] = "application/json"
            
            println(user.email)
            println(user.password)
            
            let plainString = "\(user.email):\(user.password)" as NSString
            let plainData = plainString.dataUsingEncoding(NSUTF8StringEncoding)
            let base64String = plainData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.fromRaw(0)!)
            Manager.sharedInstance.defaultHeaders["Authorization"] = "Basic " + base64String!
            
            Alamofire.request(.GET, "\(API_URL)/api/trip?XDEBUG_SESSION_START", parameters: nil).response {request, response, data, error in
                
                let json = JSONValue(data as NSData!)
                
                if json["trips"] {
                    
                    self.items.removeAll(keepCapacity: true)
                    
                    for jsonTrip in json["trips"].array!{
                        let trip = Trip.decode(jsonTrip)
                        
                        self.items.append(trip)
                    }
                }
                
                self.tableView.reloadData()
                
                if self.refreshControl.refreshing == true {
                    self.refreshControl.endRefreshing()
                }
                
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            }
            */
        }
    }
    
    // MARK: - Table View
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TripIdentifier", forIndexPath: indexPath) as UITableViewCell
        
        let trip = self.items[indexPath.row]
        
        let name = trip.name
        
        cell.textLabel?.text = name;
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let controller = segue.destinationViewController as RegionViewController
        
        var selectedIndexPathRow:Int = self.tableView.indexPathForSelectedRow()?.row as Int!
        
        let trip = self.items[selectedIndexPathRow]
    }
}
