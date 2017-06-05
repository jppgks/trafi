//
//  CompetitionTableViewCell.swift
//  Trafi
//
//  Created by Joppe Geluykens on 2017-06-05.
//  Copyright © 2017 Young Wolves. All rights reserved.
//

import UIKit

class CompetitionTableViewCell: UITableViewCell {
    // MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
