//
//  ParticipantsTableViewCell.swift
//  Trafi
//
//  Created by Joppe Geluykens on 2017-08-03.
//  Copyright © 2017 Young Wolves. All rights reserved.
//

import UIKit

class ParticipantsTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ParticipantsCell"

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var personalBestLabel: UILabel!
    @IBOutlet weak var seasonBestLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
