//
//  Base.swift
//  Tiv Bible SwiftUI
//
//  Created by Isaac Iniongun on 18/06/2021.
//

import RealmSwift

@objcMembers class Base: Object, ObjectKeyIdentifiable {
    dynamic var _id = ObjectId.generate()
    override class func primaryKey() -> String? {
        "_id"
    }
}
