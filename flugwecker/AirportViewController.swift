//
//  MasterViewController.swift
//  flugwecker
//
//  Created by Udo von Eynern on 08.08.14.
//  Copyright (c) 2014 Udo von Eynern. All rights reserved.
//

import UIKit
import Alamofire

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
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor(red: 4/255, green: 153/255, blue: 153/255, alpha: 1.0), NSFontAttributeName: UIFont(name: "Copperplate-Light", size: 20.0)]
        
        self.navigationController?.navigationBar.titleTextAttributes = titleDict
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
        
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept");
        
        manager.GET("\(API_URL)/airports-inside/de",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,data: AnyObject!) in
                
                let json = JSONValue(data as NSDictionary!)

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
                
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                
            },
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                println("Error: " + error.localizedDescription)
        });
    }

    // MARK: - Table View
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("AirportIdentifier", forIndexPath: indexPath) as UITableViewCell
        
        let airport = self.items[indexPath.row]
        
        let name = airport.name
        
        cell.textLabel?.text = name;
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let controller = segue.destinationViewController as RegionViewController
        
        var selectedIndexPathRow:Int = self.tableView.indexPathForSelectedRow()?.row as Int!

        let airport = self.items[selectedIndexPathRow]
        
        controller.selectedAirport = airport;
    }
}


