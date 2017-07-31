//
//  CompetitionDetailTableViewController.swift
//  Trafi
//
//  Created by Joppe Geluykens on 2017-06-21.
//  Copyright © 2017 Young Wolves. All rights reserved.
//

import Alamofire
import SwiftyJSON
import UIKit

class CompetitionDetailTableViewController: UITableViewController {
    var competitionId = ""
    var events = [Event]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadEvents()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    /// Reads competition data from Trafi API and stores them in a Competition list.
    private func downloadEvents() {
        
        // Send get request to Trafi API for competitions
        Alamofire.request("https://api.trafi.be/competitions/" + competitionId + "/registers").validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                // Create SwiftyJSON object from response result
                let json = JSON(value)
                // Create Competition object from each subJson in the json array
                for (_,subJson):(String, JSON) in json {
                    self.events.append(Event(subJson)!)
                }
                // Events array now has elements 🎉
                self.tableView!.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        // TODO: section for men/women?
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CompetitionDetailCell", for: indexPath) as? CompetitionDetailTableViewCell else {
            fatalError("The dequeued cell is not an instance of CompetitionDetailTableViewCell.")
        }
        
        //Configure the cell...
        cell.titleLabel.text = events[indexPath.row].name
        
        return cell
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier ?? "" {
        case "seeMore":
            guard (sender as? CompetitionsCollectionViewCell) != nil else {
                fatalError("Unexpected sender \(sender!)")
            }
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier!)")
        }
    }

}
