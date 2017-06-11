//
//  ShortcutIdentifier.swift
//  Trafi
//
//  Created by Joppe Geluykens on 2017-06-11.
//  Copyright © 2017 Young Wolves. All rights reserved.
//

import Foundation

enum ShortcutIdentifier: String {
    case OpenCompetitions
    
    init?(identifier: String) {
        guard let shortIdentifier = identifier.components(separatedBy: ".").last else {
            return nil
        }
        self.init(rawValue: shortIdentifier)
    }
}
