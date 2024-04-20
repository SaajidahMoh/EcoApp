//
//  LocationDetailView.swift
//  EcoApp
//
//  Created by Saajidah Mohamed on 20/04/2024.
//
//

import SwiftUI

struct LocationDetailView: View {
    
    let location : Location
    
    var body: some View {
        Text("Hello World")
        /**ScrollView {
            VStack {
                TabView {
                    ForEach()
                }
            }
        } */
    }

}


#Preview {
    LocationDetailView(location: LocationsDataService.locations.first!)
}
