//
//  NewItemView.swift
//  EcoApp
//
//  Created by Saajidah Mohamed on 24/03/2024.
// https://www.youtube.com/watch?v=6b2WAePdiqA&ab_channel=LoganKoshenka: Complete SwiftUI Firebase Tutorial: Auth, Sign Up Page, Cloud Firestore, Read & Write Data

import SwiftUI

struct NewItemView: View {
    var body: some View {
        Text("Hello World")
    }
    /**
    @EnvironmentObject var dataManager: DataManager
    @State private var newItem = ""
    
    
    var body: some View {
        VStack{
            TextField("Item", text:$newItem)
            
            Button {
                dataManager.addItem(itemName: newItem)
                // add item
            } label : {
                Text("Save")
            }
        }
        .padding()
    }
    */
}

#Preview {
    NewItemView()
}
