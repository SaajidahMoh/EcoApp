//
//  LocationsViewModel.swift
//  EcoApp
//
//  Created by Saajidah Mohamed on 20/04/2024.
//
//

import Foundation
import MapKit
import SwiftUI

class LocationsViewModel : ObservableObject {
    
    //all loaded locations https://www.youtube.com/watch?v=EA4lQBrnvds&list=PLwvDm4Vfkdpha5eVTjLM0eRlJ7-yDDwBk&index=4&ab_channel=SwiftfulThinking
    @Published var locations : [Location]
    @Published var selectedLocation : Location?
    
    @Published var showLocationsList: Bool = false
    @Published var showLocationsPreview: Bool = false //own code 
    //@StateObject private var isSwiped = false
    @Published var isSwiped: Bool = false 
    
    //only one location the current
        //current location on map https://www.youtube.com/watch?v=EA4lQBrnvds&list=PLwvDm4Vfkdpha5eVTjLM0eRlJ7-yDDwBk&index=4&ab_channel=SwiftfulThinking
    @Published var mapLocation: Location {
        // everytime we set the value for map location, we then call update map region
        didSet {
            updateMapRegion(location: mapLocation)
        }
    }
    
    //empty, and update caurrent location^^
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    
    init(){ //setting up locations
        let locations = LocationsDataService.locations
        self.locations = locations
        self.mapLocation = locations.first! //[has atleast one, we wrap because its our data ]
        self.updateMapRegion(location: locations.first!)
    }
    
    // Method to toggle preview view
       func toggleLocationPreview(location: Location) {
           if mapLocation == location {
               showLocationsPreview.toggle()
           } else {
               showLocationsPreview = true
               mapLocation = location
           }
       }
    
    func showNextLocation(location: Location){
        withAnimation(.easeInOut){
            mapLocation = location
            showLocationsList = false
            showLocationsPreview = true //own code
        }
        
    }
    func selectLocation(_ location: Location){
        self.selectedLocation = location
    }
    
    // change from blank to the current one. 
    private func updateMapRegion(location: Location) {
        withAnimation(.easeInOut) {
            mapRegion = MKCoordinateRegion(center:location.coordinates, span: mapSpan)
        }
    }
}
