//
//  RegionSelectionViewController.swift
//  flugwecker
//
//  Created by Udo von Eynern on 05.11.14.
//  Copyright (c) 2014 Udo von Eynern. All rights reserved.
//

import UIKit

protocol RegionSelectionProtocol
{
    func didSelectAirports(items: Array<Airport>)
}

class RegionSelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AirportSelectionProtocol {
    
    var items = [Region]()
    
    var selectedItems = [Airport]()
    
    var selectedRegion:Region = Region()
    
    var delegate:RegionSelectionProtocol?
    
    @IBOutlet var tableView : UITableView!
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if self.items.count == 0 {
            self.loadItems()
        }
    }
    
    func didSelectAirports(items: Array<Airport>) {
        
        // loop through all airports of region
        for airport in self.selectedRegion.airportsList {
            
            if contains(items, airport) {
                let index = (self.selectedItems as NSArray).indexOfObject(airport)
                
                if index == NSNotFound {
                    self.selectedItems.append(airport)
                }
            } else {
                
                let index = (self.selectedItems as NSArray).indexOfObject(airport)
                
                if index != NSNotFound {
                    self.selectedItems.removeAtIndex(index)
                }
                

            }
        }
        
        self.tableView.reloadData()

    }
    
    @IBAction func doneButtonTouched(sender: UIBarButtonItem) {
        
        self.delegate?.didSelectAirports(self.selectedItems)
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func loadItems() {
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        var findRegions:PFQuery = Region.query()
        findRegions.orderByAscending("name")
        findRegions.includeKey("airportsList")
        
        findRegions.findObjectsInBackgroundWithBlock { (objects:[AnyObject]!, error:NSError!) -> Void in
            if !(error != nil) {
                
                self.items.removeAll(keepCapacity: true)
                
                for region in objects as [Region] {
                    self.items.append(region as Region)
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
        
        let region = self.items[indexPath.row]
        
        let name = region.name
        
        cell.textLabel.text = name;
        
        // loop through all airports of this region
        var airportCodes = [String]()
        for airport in region.airportsList {
            
            if contains(self.selectedItems, airport) {
                airportCodes.append(airport.code)
            }
        }
        
        if airportCodes.count > 0 {
            cell.detailTextLabel?.text = join(", ", airportCodes)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let region = self.items[indexPath.row]
        self.selectedRegion = region
        
        var cell = self.tableView.cellForRowAtIndexPath(indexPath)
        
        var airportSelectionViewController:AirportSelectionViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AirportSelectionViewController") as AirportSelectionViewController
        airportSelectionViewController.items = region.airportsList
        airportSelectionViewController.delegate = self
        
        self.navigationController?.pushViewController(airportSelectionViewController, animated: true)
    }
    

}