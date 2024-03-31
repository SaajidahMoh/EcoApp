//
//  FoodBanks.swift
//  EcoApp
//
//  Created by Saajidah Mohamed on 31/03/2024.
//

import SwiftUI
import MapKit

struct FoodBanks: View {
    @State private var locations: [Location] = []
    private func loadLocations() async {
        do {
            locations = try await LocationClient.shared.fetchLocations(at: Constants.Urls.locations)
        } catch {
            print(error.localizedDescription)
        }
    }
    var body: some View {
        Map{
            ForEach(locations) { location in
                Marker(location.name, coordinate: location.coordinate)
            }
        }
        //Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        .task {
            await loadLocations()
        }
    }
}


#Preview {
    FoodBanks()
}
