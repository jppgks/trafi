//
//  CompetitionTableViewController.swift
//  Trafi
//
//  Created by Joppe Geluykens on 2017-06-05.
//  Copyright © 2017 Young Wolves. All rights reserved.
//

import Alamofire
import SwiftyJSON
import UIKit

class CompetitionTableViewController: UITableViewController {
    
    var competitions = [Competition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        downloadCompetitions()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Download data
    
    /// Reads competition data from Trafi API and stores them in a Competition list.
    private func downloadCompetitions() {
        
        // Send get request to Trafi API for competitions
        Alamofire.request("https://api.trafi.be/competitions").validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                // Create SwiftyJSON object from response result
                let json = JSON(value)
                // Create Competition object from each subJson in the json array
                for (_,subJson):(String, JSON) in json {
                    self.competitions.append(Competition(subJson)!)
                }
                // Competition array now has elements 🎉
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return competitions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Cell identifier as set in storyboard
        let cellIdentifier = "CompetitionTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CompetitionTableViewCell else {
            fatalError("The dequeued cell is not an instance of CompetitionTableViewCell.")
        }
        
        let competition = competitions[indexPath.row]
        
        cell.nameLabel.text = competition.name
        cell.dateLabel.text = competition.date
        cell.locationLabel.text = competition.location
        
        // Add shadow to cardView...
        cell.cardView.layer.masksToBounds = false
        cell.cardView.layer.shadowRadius = 10.0
        cell.cardView.layer.shadowOpacity = 0.1
        cell.cardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.cardView.layer.shadowColor = UIColor.black.cgColor
        
        // ...and corners!
        cell.cardView.layer.cornerRadius = 10.0
        
        // Make our cardView layer visible
        cell.contentView.backgroundColor = nil
        
        // Increase padding in between cells
        let f = cell.contentView.frame
        let fr = UIEdgeInsetsInsetRect(f, UIEdgeInsetsMake(30, 30, 30, 30))
        cell.contentView.frame = fr
        
        return cell
    }

}
