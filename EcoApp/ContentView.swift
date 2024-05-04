//
//  ContentView.swift
//  EcoApp
//
//  Created by Saajidah Mohamed 
/**
 * TabView code was reused and adapted from the video below to allow ease of navigation through the main views.
 * Allen, S. (2021), SwiftUI - TabView Tutorial. YouTube video available at: https://www.youtube.com/watch?v=tnNFoZ7CkP8&ab_channel=SeanAllen
 */

import SwiftUI
import Firebase

struct ContentView: View {
    @StateObject var itemsViewModel = ItemsViewModel()
    @StateObject private var locationsViewModel = LocationsViewModel()
    @AppStorage("log_status") private var logStatus: Bool = false
    @AppStorage("isOnboarding") var isOnBoarding: Bool = true
    
    var body: some View {
        // User Logged in
        if logStatus {
            // To navigate through the pages.
            TabView {
                ListView()
                    .environmentObject(itemsViewModel)
                    .tabItem { Label("Home", systemImage:"globe.europe.africa")}
                
                LocationsView()
                    .environmentObject(locationsViewModel)
                    .tabItem { Label("Food Banks", systemImage: "mappin.and.ellipse")}
                
                recipeSearch()
                    .tabItem { Label("Recipes", systemImage: "fork.knife")}
                
                RecipeListView()
                    .tabItem { Label("Favourites", systemImage: "star")}
                
                Settings()
                    .tabItem { Label("Settings", systemImage: "gear")}
            }
            .accentColor(.green)
        } else {
            // User not logged in, directs user to the logo
            SplashScreenView()
        }
    }
}

#Preview {
    ContentView()
}
