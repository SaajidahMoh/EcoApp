//
//  TabBar.swift
//  EcoApp
//
//  Created by Saajidah Mohamed on 22/03/2024.
//

import SwiftUI

struct TabBar: View {
    var body: some View {
        //Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        TabView {
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
         .accentColor(.green)
    }
}

/** TabView {
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
.accentColor(.green)*/
#Preview {
    TabBar()
}
