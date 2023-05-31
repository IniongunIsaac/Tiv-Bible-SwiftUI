//
//  Code+Utils.swift
//  TivBible
//
//  Created by Isaac Iniongun on 31/05/2023.
//

import Foundation

extension Collection {
    var isNotEmpty: Bool {
        !isEmpty
    }
}

@discardableResult func with<T>(_ it: T, f:(T) -> ()) -> T {
    f(it)
    return it
}

extension Int {
    var int16: Int16 {
        Int16(self)
    }
}

extension Int16 {
    var int: Int {
        Int(self)
    }
}
