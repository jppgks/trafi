//
//  CompetitionDetailTableViewCell.swift
//  Trafi
//
//  Created by Joppe Geluykens on 2017-07-31.
//  Copyright © 2017 Young Wolves. All rights reserved.
//

import UIKit

class CompetitionDetailTableViewCell: UITableViewCell {
    static let reuseIdentifier = "CompetitionDetailCell"

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
