//
//  TivBibleDTO.swift
//  Tiv Bible SwiftUI
//
//  Created by Isaac Iniongun on 18/06/2021.
//

import Foundation

struct TivBibleDTO: Codable, Scopable {
    let book: String
    let chapter: Int
    let verse: Int
    let text: String
    let title: String
    let testament: String
    let orderNo: Int
}
