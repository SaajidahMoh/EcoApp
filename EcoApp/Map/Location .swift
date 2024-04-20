//
//  Location .swift
//  EcoApp
//
//  Created by Saajidah Mohamed on 20/04/2024.
//
//model
import Foundation
import MapKit

struct Location : Identifiable, Equatable{
  //  let id = UUID().uuidString //random generated ID
    let name : String
    let address : String
    let cityName : String
    let postcode : String
    let coordinates : CLLocationCoordinate2D
    let phone : String
    let email : String
    let link : String
    
    var id: String {
        name + " ," + cityName
    }
    
//https://www.youtube.com/watch?v=OrbZBOFOa7Q&list=PLwvDm4Vfkdpha5eVTjLM0eRlJ7-yDDwBk&index=5&ab_channel=SwiftfulThinking
    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.id == rhs.id
    }
}
