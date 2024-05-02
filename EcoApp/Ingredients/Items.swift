//
//  Items.swift
//  EcoApp
//
//  Created by Saajidah Mohamed
//

import SwiftUI
import Firebase

// model was developed by me to initialise my items. 
struct Items: Identifiable {
    var id: String
    var name: String
    var isChecked: Bool
    var quantity : Int
    var expiryDate : Timestamp
    var selection : String
    var description : String
    var imageURL : String
}
