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
    @EnvironmentObject var itemsViewModel: ItemsViewModel
    @State private var showPopup = false
    
    var body: some View {
        NavigationView {
            Button("Logout"){
                try? Auth.auth().signOut()
                logStatus = false
                
                
            }
            List(itemsViewModel.items, id: \.id ) {items in
                Text(items.name)
            }
            .navigationTitle("Ingredients")
            .navigationBarItems(trailing: Button(action: {
                showPopup.toggle()
                // add
                //dataManager.addItem(itemName: newItem)
            }, label: {
                Image(systemName: "plus")
            }))
           // .sheet(isPresented: $showPopup)
             //     { NewItemView()
                /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Content@*/Text("Sheet Content")/*@END_MENU_TOKEN@*/
              //    }
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


