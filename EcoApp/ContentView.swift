//
//  ContentView.swift
//  EcoApp
//
//  Created by Saajidah Mohamed on 18/03/2024.
// https://www.youtube.com/watch?v=tnNFoZ7CkP8&ab_channel=SeanAllen

import SwiftUI
import Firebase

struct ContentView: View {
    @StateObject var itemsViewModel = ItemsViewModel()
    @StateObject private var vm = LocationsViewModel()
   // @StateObject var viewModel = FavViewModel()
    @AppStorage("log_status") private var logStatus: Bool = false
    
    var body: some View {
        if logStatus {
            // Home
            //Home()
            
            TabView {
                ListView()
                    . environmentObject(itemsViewModel)
                    .tabItem {
                    Label("Home", systemImage:"globe.europe.africa")
                    //.foregroundColor(Color.green)//"house"
                    }
               // MapView()
                LocationsView()
                    .environmentObject(vm)
                //FoodBanks()
                    //Text("Maps")
                    .tabItem { Label("Food Banks",
                    ////systemImage: "mappin"
                    systemImage: //"figure.walk"
                    "mappin.and.ellipse")}
                    
                recipeSearch()
                    //Text("Recipes")
                    .tabItem { Label("Recipes", systemImage: "fork.knife")
                    // .foregroundColor(Color.green)
                    }
                //FavouritesCardView(recipeDocument: recipeDocument)
                     /// RecipeListView()
                //    .environmentObject(viewModel)
              
                   // Text("Favourites")
                //RecipeCardsView()
                RecipeListView()
                    .tabItem { Label("Favourites", systemImage: "star")}
                    
                    //Text("Settings")
                SettingsView()
                    .tabItem { Label("Settings", systemImage:
                    //shape
                    "gear")}
             //Home()
        
             
             
             
             }
             .accentColor(.green)
        } else {
            Login()
        }
       /** VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding() */
        //Text("Hello, world!")
    }
}

#Preview {
    ContentView()
}
