//
//  MasterViewController.swift
//  flugwecker
//
//  Created by Udo von Eynern on 08.08.14.
//  Copyright (c) 2014 Udo von Eynern. All rights reserved.
//

import UIKit
import CoreData

class AirportViewController: UITableViewController {
    
    var items = [JSONValue]()
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)

        Alamofire.Manager.sharedInstance.defaultHeaders["Accept"] = "application/json"

        Alamofire.request(.GET, "http://www.flugwecker.de/airports", parameters: nil).response {request, response, data, error in
            let json = JSONValue(data as NSData)
            
            for airport in json["airports"].array!{
                self.items.append(airport)
            }
            
            self.tableView.reloadData()
        }

    }

    // MARK: - Table View
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }

    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let object: JSONValue = self.items[indexPath.row]
        
        let name = object["name"].string!

        cell.textLabel.text = name;
    }
}

