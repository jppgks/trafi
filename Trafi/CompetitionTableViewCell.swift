//
//  CompetitionTableViewCell.swift
//  Trafi
//
//  Created by Joppe Geluykens on 2017-06-05.
//  Copyright © 2017 Young Wolves. All rights reserved.
//

import Pastel
import UIKit

class CompetitionTableViewCell: UITableViewCell {
    // MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var pastelView: PastelView!
    @IBOutlet weak var moreButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
