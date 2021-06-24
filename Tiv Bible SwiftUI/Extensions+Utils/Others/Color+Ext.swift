//
//  Color+Ext.swift
//  Tiv Bible SwiftUI
//
//  Created by Isaac Iniongun on 18/06/2021.
//

import UIKit
import SwiftUI

extension Color {
    
    //MARK: - App Colors
    static let primaryColor = Color.color("#008577")
    
    //MARK: - Color from HexString
    static func color(_ hex: String, alpha: CGFloat = 1.0) -> Color { Color(UIColor(hex, alpha)) }
    
    // MARK: - Text Colors
    static let lightText = Color(.lightText)
    static let darkText = Color(.darkText)
    static let placeholderText = Color(.placeholderText)
    
    // MARK: - Label Colors
    static let label = Color(.label)
    static let secondaryLabel = Color(.secondaryLabel)
    static let tertiaryLabel = Color(.tertiaryLabel)
    static let quaternaryLabel = Color(.quaternaryLabel)
    
    // MARK: - Background Colors
    static let systemBackground = Color(.systemBackground)
    static let secondarySystemBackground = Color(.secondarySystemBackground)
    static let tertiarySystemBackground = Color(.tertiarySystemBackground)
    
    // MARK: - Fill Colors
    static let systemFill = Color(.systemFill)
    static let secondarySystemFill = Color(.secondarySystemFill)
    static let tertiarySystemFill = Color(.tertiarySystemFill)
    static let quaternarySystemFill = Color(.quaternarySystemFill)
    
    // MARK: - Grouped Background Colors
    static let systemGroupedBackground = Color(.systemGroupedBackground)
    static let secondarySystemGroupedBackground = Color(.secondarySystemGroupedBackground)
    static let tertiarySystemGroupedBackground = Color(.tertiarySystemGroupedBackground)
    
    // MARK: - Gray Colors
    static let systemGray = Color(.systemGray)
    static let systemGray2 = Color(.systemGray2)
    static let systemGray3 = Color(.systemGray3)
    static let systemGray4 = Color(.systemGray4)
    static let systemGray5 = Color(.systemGray5)
    static let systemGray6 = Color(.systemGray6)
    
    // MARK: - Other Colors
    static let separator = Color(.separator)
    static let opaqueSeparator = Color(.opaqueSeparator)
    static let link = Color(.link)
    
    // MARK: System Colors
    static let systemBlue = Color(.systemBlue)
    static let systemPurple = Color(.systemPurple)
    static let systemGreen = Color(.systemGreen)
    static let systemYellow = Color(.systemYellow)
    static let systemOrange = Color(.systemOrange)
    static let systemPink = Color(.systemPink)
    static let systemRed = Color(.systemRed)
    static let systemTeal = Color(.systemTeal)
    static let systemIndigo = Color(.systemIndigo)
    
}

extension UIColor {
    convenience init(_ hexString: String, _ alpha: CGFloat = 1.0) {
        var cString:String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) { cString.removeFirst() }
        
        if ((cString.count) != 6) {
            self.init("ff0000") // return red color for wrong hex input
            return
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}
