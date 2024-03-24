//
//  Home.swift
//  EcoApp
//
//  Created by Saajidah Mohamed on 18/03/2024.
//

import SwiftUI
import Firebase


struct Home: View {
    @AppStorage("log_status") private var logStatus: Bool = false
    var body: some View {
    
            //Text("Hello, World!")
            NavigationStack {
                Button("Logout"){
                    try? Auth.auth().signOut()
                    logStatus = false
                    
                    
                }
                .padding(.bottom, 10)
                //.padding()
                
                .navigationTitle("Home")
            }
        NavigationView{
            VStack {
                
            }
        }
            
        }
    }

enum Tab{
    case home, map, favourites, recipe, setting
}
#Preview {
    Home()
}
