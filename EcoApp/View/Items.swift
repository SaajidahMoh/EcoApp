//
//  Items.swift
//  EcoApp
//
//  Created by Saajidah Mohamed on 24/03/2024.
//

import SwiftUI
import Firebase


struct Items: Identifiable {
    var id: String
    var name: String
    var isChecked: Bool
    var quantity : Int
    var description : String
    // https://stackoverflow.com/questions/52367721/how-to-declare-data-type-as-timestamp-in-ios-swift
    var expiryDate : Timestamp
    //TimeInterval
    //var quantity: Number
    ///var expiry: TimeStamp
    
}
