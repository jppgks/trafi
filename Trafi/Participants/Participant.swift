//
//  Participant.swift
//  Trafi
//
//  Created by Joppe Geluykens on 2017-08-03.
//  Copyright © 2017 Young Wolves. All rights reserved.
//

import Foundation
import SwiftyJSON

class PersonalBest {
    var id: String
    var performance: String
    var year: String
    var verified: Bool
    
    init?(_ json: JSON) {
        self.id = json["id"].stringValue
        self.performance = json["performance"].stringValue
        self.year = json["year"].stringValue
        self.verified = json["verified"].boolValue
    }
}

class Participant {
    var name: String
    var team: String
    var personalBest: PersonalBest
    var seasonBest: String
    var partitionId: String
    
    // Construct object from SwiftyJSON
    init?(_ json: JSON) {
        self.name = json["name"].stringValue
        self.team = json["team"].stringValue
        self.personalBest = PersonalBest(json["pb"])!
        self.seasonBest = json["sb"].stringValue
        self.partitionId = json["partitionId"].stringValue
    }
}
