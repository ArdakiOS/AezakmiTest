//
//  DrawingTextBoxModel.swift
//  AezakmiTest
//
//  Created by Ardak Tursunbayev on 18.09.2024.
//

import Foundation
import SwiftUI

struct DrawingTextBoxModel : Identifiable {
    let id = UUID().uuidString
    var text : String
    var color : Color = .black
    var isBold : Bool = false
    var font : CGFloat = 12
    
    var offset : CGSize = .zero
    var lastOffset : CGSize = .zero
}
