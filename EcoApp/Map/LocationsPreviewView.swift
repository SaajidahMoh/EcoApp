//
// LocationsPreviewView.swift
//  EcoApp
//
//  Created by Saajidah Mohamed on 20/04/2024.
//
//

import SwiftUI
import MapKit


struct LocationsPreviewView: View {
    @State private var isSwiped: Bool = false
    
    let location: Location
    
    // https://www.youtube.com/watch?v=Ca0SisRHYuY&list=PLwvDm4Vfkdpha5eVTjLM0eRlJ7-yDDwBk&index=6&ab_channel=SwiftfulThinking
    
    var body: some View {
        
        VStack(spacing: 16) {
            VStack(alignment: .leading) {
                titleSection
            }
            HStack {
                directionsection
                websiteSection
            }
            .multilineTextAlignment(.center)
            
            if isSwiped == true {
                moreInfoSection
            } else if isSwiped == false {
                HStack {
                    Text ("Swipe up for more information")
                    Image(systemName: "arrow.up")
                } .bold()
            }
            
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial))
        /**.onTapGesture {
         withAnimation {
         isSwiped.toggle()
         }
         } */
        
        // https://developer.apple.com/tutorials/sample-apps/recognizinggestures
        // https://medium.com/@mohitgupta_48195/chapter-17-understanding-gestures-46254b783a77
        .gesture(DragGesture()
            .onEnded({ (value) in
                if (value.translation.height < 0) {
                    //animation
                    withAnimation {
                        isSwiped = true
                    }
                } else if (value.translation.height > 0) {
                    withAnimation {
                        isSwiped = false
                    }
                }
            }))
        
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 4){
            Text("\(location.name) - \(location.cityName)")
                .font(.title2)
                .fontWeight(.bold)
            Text(location.address)
            Text(location.postcode)
        }
    }
    
    
    private var moreInfoSection: some View {
        VStack(alignment: .leading, spacing: 10){
            
            Section(header: Text("Address")
                .font(.title3)
                .fontWeight(.bold)){
                    Text(location.address)}
            //  Text("\(item.quantity)")
            
            Section(header: Text("Postcode")
                .font(.title3)
                .fontWeight(.bold)
            ){
                Text(location.postcode)
            }
            
            Section(header: Text("Phone Number")
                .font(.title3)
                .fontWeight(.bold)) {
                    Text(location.phone)}
            
            Section(header: Text("Email")
                .font(.title3)
                    
                .fontWeight(.bold)) {
                    // Text(location.email)}
                    // https://forums.developer.apple.com/forums/thread/67733
                    Link(destination: URL(string: "\(location.email)")!){
                        Text(location.email)
                    }
                }
            
            
            Section(header: Text("Website URL")
                .font(.title3)
                .fontWeight(.bold)) {
                    // https://forums.developer.apple.com/forums/thread/67733
                    Link(destination: URL(string: "\(location.link)")!){
                        Text(location.link)
                    }
                }
        }
    }
    
    
    private var websiteSection: some View {
        // Link(destination: URL(string: "\(location.link)")!) {
        // https://stackoverflow.com/questions/58643888/swiftui-how-do-i-make-a-button-open-a-url-in-safari
        Button(action: {
            if let url = URL(string: "\(location.link)") {
                UIApplication.shared.open(url)
            }
        }) { Label("Website", systemImage: "link")
                .font(.headline)
                .frame(width: 132, height: 35)
        }
        .buttonStyle(.bordered)
        .foregroundColor(.green)
    }
    
    
    private var directionsection: some View {
        //Button 3
        Button(action: {
            self.openMaps(coordinate: self.location.coordinates) //  // https://www.youtube.com/watch?v=YVKuMJPGCj8&t=464s&ab_channel=ASwiftlyTiltingPlanet 20 minutes
        }) {
            Label("Directions", systemImage: "car")
                .font(.headline)
                .frame(width: 138, height: 35)
        }
        .buttonStyle(.borderedProminent)
        
        
        
        
    }
    // https://www.youtube.com/watch?v=YVKuMJPGCj8&t=464s&ab_channel=ASwiftlyTiltingPlanet 20 minutes
    func openMaps(coordinate: CLLocationCoordinate2D){
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        mapItem.openInMaps()
    }
}


#Preview {
    LocationsPreviewView(location: LocationsDataService.locations.first!)
}

