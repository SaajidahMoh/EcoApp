//
//  Location.swift
//  EcoApp
//
//  Created by Saajidah Mohamed
//

import Foundation
import MapKit

/**
 * The locations model initialises the data. The code was reused and adapted from the video below to fit what data I needed.
 * Sarno, N. (2021), Swiftful Thinking - Using a List as a custom animated menu | SwiftUI Map App #4. Link available at : https://www.youtube.com/watch?v=OrbZBOFOa7Q&ab_channel=SwiftfulThinking
 */

struct Location : Identifiable, Equatable{
    let name : String
    let address : String
    let cityName : String
    let postcode : String
    let coordinates : CLLocationCoordinate2D
    let phone : String
    let email : String
    let link : String
    
    /**
     * The variable below was reused from the video below to create a new ID with the name and the city's name.
     * Sarno, N. (2021), Swiftful Thinking - Using a List as a custom animated menu | SwiftUI Map App #4. Link available at: https://www.youtube.com/watch?v=OrbZBOFOa7Q&ab_channel=SwiftfulThinking
     */
    var id: String {
        name + " ," + cityName
    }
    
    /**
     * The location's function was reused from the video below to compare 2 locations. No 2 different locations should have the same ID.
     * Sarno, N. (2021), Swiftful Thinking - Using a List as a custom animated menu | SwiftUI Map App #4. Link available at: https://www.youtube.com/watch?v=OrbZBOFOa7Q&ab_channel=SwiftfulThinking
     */
    // checks if 2 locations have the same ID. If they are it's the same location.
    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.id == rhs.id
    }
}
