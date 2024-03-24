//
//  ListView.swift
//  EcoApp
//
//  Created by Saajidah Mohamed on 24/03/2024.
//

import SwiftUI
import Firebase

struct ListView: View {
    @AppStorage("log_status") private var logStatus: Bool = false
    @EnvironmentObject var dataManager: DataManager
    @State private var showPopup = false
    
    var body: some View {
        NavigationView {
            Button("Logout"){
                try? Auth.auth().signOut()
                logStatus = false
                
                
            }
            List(dataManager.items, id: \.id ) {items in
                Text(items.name)
            }
            .navigationTitle("Ingredients")
            .navigationBarItems(trailing: Button(action: {
                // add
                //dataManager.addItem(itemName: newItem)
            }, label: {
                Image(systemName: "plus")
            }))
            Button("Logout"){
                try? Auth.auth().signOut()
                logStatus = false
                
                
            }
            .padding(.bottom, 10)
        }
   
    }
}

#Preview {
    ListView()
       // .environmentObject(dataManager)
}


