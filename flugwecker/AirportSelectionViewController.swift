//
//  AirportSelectionViewController.swift
//  flugwecker
//
//  Created by Udo von Eynern on 01.11.14.
//  Copyright (c) 2014 Udo von Eynern. All rights reserved.
//

import UIKit

protocol AirportSelectionProtocol
{
    func didSelectAirports(items: Array<Airport>)
}

class AirportSelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var items = [Airport]()
    
    var selectedItems = [Airport]()
    
    var delegate:AirportSelectionProtocol?
    
    var filteredByCountry = ""
    
    @IBOutlet var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
    }

    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if self.items.count == 0 {
            self.loadItems()
        }
        
    }
    
    @IBAction func doneButtonTouched(sender: UIBarButtonItem) {
        
        self.delegate?.didSelectAirports(self.selectedItems)
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func loadItems() {
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        var findAirports:PFQuery = Airport.query()
        if self.filteredByCountry != "" {
            findAirports.whereKey("country", equalTo: self.filteredByCountry)
        }
        findAirports.orderByAscending("name")
        
        findAirports.findObjectsInBackgroundWithBlock { (objects:[AnyObject]!, error:NSError!) -> Void in
            if !(error != nil) {
                
                self.items.removeAll(keepCapacity: true)
                
                for airport in objects as [Airport] {
                    self.items.append(airport as Airport)
                }
                
                self.tableView.reloadData()
                
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let airport = self.items[indexPath.row]
        
        var cell = self.tableView.cellForRowAtIndexPath(indexPath)
        
        if contains(self.selectedItems, airport) == false {
            self.selectedItems.append(airport)
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            
            let index = (self.selectedItems as NSArray).indexOfObject(airport)
            
            self.selectedItems.removeAtIndex(index)
            cell?.accessoryType = UITableViewCellAccessoryType.None
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let airport = self.items[indexPath.row]
        
        var cell = self.tableView.cellForRowAtIndexPath(indexPath)
        
        if contains(self.selectedItems, airport) == false {
            self.selectedItems.append(airport)
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            
            let index = (self.selectedItems as NSArray).indexOfObject(airport)
            
            self.selectedItems.removeAtIndex(index)
            cell?.accessoryType = UITableViewCellAccessoryType.None
        }
    }
}