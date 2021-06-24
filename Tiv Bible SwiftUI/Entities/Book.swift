//
//  Book.swift
//  Tiv Bible SwiftUI
//
//  Created by Isaac Iniongun on 18/06/2021.
//

import Foundation
import RealmSwift

@objcMembers class Book: BaseName {
    dynamic var orderNo = 0
    dynamic var numberOfChapters = 0
    dynamic var numberOfVerses = 0
    dynamic var testament: Testament?
    dynamic var version: Version?
    var chapters = List<Chapter>()
    
    var bookName: String { name.lowercased().capitalized }
    
    convenience required init(name: String, orderNo: Int, numberOfChapters: Int, numberOfVerses: Int, testament: Testament, version: Version) {
        self.init()
        self.name = name
        self.orderNo = orderNo
        self.numberOfChapters = numberOfChapters
        self.numberOfVerses = numberOfVerses
        self.testament = testament
        self.version = version
    }
    
}
