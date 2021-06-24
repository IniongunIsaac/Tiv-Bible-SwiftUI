//
//  RecentSearch.swift
//  Tiv Bible SwiftUI
//
//  Created by Isaac Iniongun on 18/06/2021.
//

import Foundation
import RealmSwift

@objcMembers class RecentSearch: Object {
    dynamic var text = ""
    
    override static func primaryKey() -> String? { "text" }
    
    convenience required init(text: String) {
        self.init()
        self.text = text
    }
}
