//
//  ParticipantsTableViewController.swift
//  Trafi
//
//  Created by Joppe Geluykens on 2017-08-03.
//  Copyright © 2017 Young Wolves. All rights reserved.
//

import Alamofire
import ChameleonFramework
import PullToDismiss
import SwiftyJSON
import UIKit

class ParticipantsTableViewController: UITableViewController {
    var competitionId = ""
    var event: Event? = nil
    
    var participants = [Participant]()
    
    var pullToDismiss: PullToDismiss?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadParticipants()
        
        // Pull to dismiss
        pullToDismiss = PullToDismiss(scrollView: self.tableView)
        pullToDismiss?.dismissAction = { [weak self] in
            self?.dismiss(animated: true)
        }
        pullToDismiss?.delegate = self
        pullToDismiss?.backgroundEffect = BlurEffect.dark
        pullToDismiss?.dismissableHeightPercentage = 0.5

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Navigation bar styling
        self.navigationController?.hidesNavigationBarHairline = true
        self.navigationController?.navigationBar.tintColor = ContrastColorOf(FlatYellow(), returnFlat: true)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: ContrastColorOf(FlatYellow(), returnFlat: true)]
        
        // Status bar styling
        self.setStatusBarStyle(UIStatusBarStyleContrast)
        
        self.tableView?.backgroundColor = FlatWhiteDark()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Reads participants data from Trafi API and stores them in a Participants list.
    private func downloadParticipants() {
        // Send get request to Trafi API for competitions
        Alamofire.request("https://api.trafi.be/competition/" + competitionId + "/register/" + event!.id + "/participants").validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                // Create SwiftyJSON object from response result
                let json = JSON(value)
                // Create Participant object from each subJson in the json array
                for (_,subJson):(String, JSON) in json {
                    self.participants.append(Participant(subJson)!)
                }
                // Participants array now has elements 🎉
                self.tableView!.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        // TODO: section for men/women?
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return participants.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ParticipantsCell", for: indexPath) as? ParticipantsTableViewCell else {
            fatalError("The dequeued cell is not an instance of ParticipantsTableViewCell.")
        }
        
        // Styling
        cell.contentView.backgroundColor = .white
        let contrastColor = ContrastColorOf(cell.contentView.backgroundColor!, returnFlat: true)
        
        cell.nameLabel.textColor = contrastColor
        cell.teamLabel.textColor = contrastColor
        cell.seasonBestLabel.textColor = contrastColor
        cell.personalBestLabel.textColor = contrastColor
        
        // Display data
        cell.nameLabel.text = participants[indexPath.row].name
        cell.teamLabel.text = participants[indexPath.row].team
        cell.seasonBestLabel.text = participants[indexPath.row].seasonBest
        cell.personalBestLabel.text = participants[indexPath.row].personalBest.performance
        
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
        case "seeParticipants":
            guard (sender as? CompetitionDetailTableViewCell) != nil else {
                fatalError("Unexpected sender \(sender!)")
            }
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier!)")
        }
    }

}
