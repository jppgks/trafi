//
//  Event.swift
//  Trafi
//
//  Created by Joppe Geluykens on 2017-06-09.
//  Copyright © 2017 Young Wolves. All rights reserved.
//

import Foundation
import SwiftyJSON

class Event {
    var id: String
    var name: String
    var registerName: String
    var eventName: String
    var eventType: String
    
    // Construct object from SwiftyJSON
    init?(_ json: JSON) {
        self.id = json["id"].stringValue
        self.name = json["name"].stringValue
        self.registerName = json["registerName"].stringValue
        self.eventName = json["eventName"].stringValue
        self.eventType = json["eventType"].stringValue
    }
}
