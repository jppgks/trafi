//
//  Competition.swift
//  Trafi
//
//  Created by Joppe Geluykens on 2017-06-05.
//  Copyright © 2017 Young Wolves. All rights reserved.
//

import Foundation
import SwiftyJSON

class Competition {
    var id: String
    var name: String
    var date: String
    var location: String
    var open: Bool
    var state: String
    
    var events = [Event]()
    
    // Construct object from SwiftyJSON
    init?(_ json: JSON) {
        self.id = json["id"].stringValue
        self.name = json["name"].stringValue
        self.date = json["date"].stringValue
        self.location = json["location"].stringValue
        self.open = json["open"].boolValue
        self.state = json["state"].stringValue
    }
}
