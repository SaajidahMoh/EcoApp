//
//  LocationsViewModel.swift
//  EcoApp
//
//  Created by Saajidah Mohamed
//

import Foundation
import MapKit
import SwiftUI

class LocationsViewModel : ObservableObject {
    // own code
    @Published var showLocationsPreview: Bool = false
    @Published var isSwiped: Bool = false
    
    /** The variables below from locations to mapRegion were reused from the video. The map location was reused to update the map region - It shows only one location on the map at a time (the current selected one).
     * Sarno, N. (2021), Swiftful Thinking - Add Map to SwiftUI project with MapKit | SwiftUI Map App #3. Link available at :
     * https://www.youtube.com/watch?v=EA4lQBrnvds&ab_channel=SwiftfulThinking
     */
    
    @Published var locations : [Location]
    @Published var selectedLocation : Location?
    @Published var showLocationsList: Bool = false
    
    @Published var mapLocation: Location {
        didSet {
            updateMapRegion(location: mapLocation)
        }
    }
    
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    
    /** The init initalisation was reused from the video to set up the loctions.
     * Sarno, N. (2021), Swiftful Thinking - Add Map to SwiftUI project with MapKit | SwiftUI Map App #3. Link available at :
     * https://www.youtube.com/watch?v=EA4lQBrnvds&ab_channel=SwiftfulThinking
     */
    init(){ //setting up locations
        let locations = LocationsData.locations
        self.locations = locations
        self.mapLocation = locations.first! //[has atleast one, we wrap because its our data]
        self.updateMapRegion(location: locations.first!)
    }
    
    // code was created by me to show the information of the location when tapped and to remove it when tapped again.
    // If a new location is selected it is updated, but if the same one is selected it toggles it (usually remove) 
    func toggleLocationPreview(location: Location) {
        if mapLocation == location {
            showLocationsPreview.toggle()
        } else {
            showLocationsPreview = true
            mapLocation = location
        }
    }
    
    /** The show next location function was reused to update the map region. It shows only one location on the map at a time (the current selected one).
     * Sarno, N. (2021), Swiftful Thinking - Add Map to SwiftUI project with MapKit | SwiftUI Map App #3. Link available at :
     * https://www.youtube.com/watch?v=EA4lQBrnvds&ab_channel=SwiftfulThinking
     */
    func showNextLocation(location: Location){
        withAnimation(.easeInOut){
            mapLocation = location
            showLocationsList = false
            showLocationsPreview = true //own code
        }
    }
    
    /** The update map region function was reused Changes from blank to the current location
     * Sarno, N. (2021), Swiftful Thinking - Add Map to SwiftUI project with MapKit | SwiftUI Map App #3. Link available at :
     * https://www.youtube.com/watch?v=EA4lQBrnvds&ab_channel=SwiftfulThinking
     */
    private func updateMapRegion(location: Location) {
        withAnimation(.easeInOut) {
            mapRegion = MKCoordinateRegion(center:location.coordinates, span: mapSpan)
        }
    }
}
