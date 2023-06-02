//
//  PreferenceStore.swift
//  TivBible
//
//  Created by Isaac Iniongun on 02/06/2023.
//

import Foundation
import SwiftUI

final class PreferenceStore: ObservableObject {
    @AppStorage(.hasSetupDB) var hasSetupDB: Bool = false
}
