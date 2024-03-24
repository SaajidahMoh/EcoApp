//
//  Ingredients.swift
//  EcoApp
//
//  Created by Saajidah Mohamed on 19/03/2024.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct Ingredients: View {
  //  @StateObject var vm = InventoryListVM()
    
    var body: some View {
            
        NavigationView{
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        
            .navigationTitle("Home");
        }
        
           
        /** List {
         ForEach(vm.items) {
         item in
         Text(item.name)
         }
         }
         .navigationTitle("Ingredients")
         .onAppear {
         vm.listenToItems() */
        // }
        
        
        
        /**TabView {
         Home()
         .tabItem {
         Label("Home", systemImage:"globe.europe.africa")
         //.foregroundColor(Color.green)//"house"
         }
         Text("Maps")
         .tabItem { Label("Food Banks",
         ////systemImage: "mappin"
         systemImage: //"figure.walk"
         "mappin.and.ellipse")}
         
         Text("Recipes")
         .tabItem { Label("Recipes", systemImage: "fork.knife")
         // .foregroundColor(Color.green)
         }
         
         Text("Favourites")
         .tabItem { Label("Favourites", systemImage: "star")}
         
         Text("Settings")
         .tabItem { Label("Settings", systemImage:
         //shape
         "gear")}
         
         
         }
         .accentColor(.green) */
        //.padding(-5)
        
     
    }
  
}

#Preview {
    Ingredients()
}
