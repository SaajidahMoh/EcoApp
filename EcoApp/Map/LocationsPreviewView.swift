//
// LocationsPreviewView.swift
//  EcoApp
//
//  Created by Saajidah Mohamed
//
//

import SwiftUI
import MapKit

/**
 * The locations preview view below were reused and adapted to create my view, adjusting to fit my data. The gesture and isSwiped code were developed by me.
 * Sarno, N. (2021), Swiftful Thinking - Location Preview cards with asymmetric Transitions | SwiftUI Map App #5. Link available at : https://www.youtube.com/watch?v=Ca0SisRHYuY&ab_channel=SwiftfulThinking
 */

// The view of the locations information sheet
struct LocationsPreviewView: View {
    @State private var isSwiped: Bool = false
    
    let location: Location
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
            
            // if and else if code was developed by me
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
        
        /**
         * The gesture below was adapted and experimented to allow users to swipe up and down to view more information. The code was developed by me using the 2 documents:
         * Gupta, M. (2023), Chapter 17: Understanding Gestures. Link available at: https://medium.com/@mohitgupta_48195/chapter-17-understanding-gestures-46254b783a77
         * Apple (2024), Sample Apps Tutorial: Responding to User Input, Recognizing Gestures. Link available at: https://developer.apple.com/tutorials/sample-apps/recognizinggestures
         */
        .gesture(DragGesture()
            .onEnded({ (value) in
                if (value.translation.height < 0) {
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
    
    /**
     * The variables below were adapted for the purpose of simplifying the view without the code beign too compact.
     * Sarno, N. (2021), Swiftful Thinking - Location Preview cards with asymmetric Transitions | SwiftUI Map App #5. Link available at : https://www.youtube.com/watch?v=Ca0SisRHYuY&ab_channel=SwiftfulThinking
     */
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 4){
            Text("\(location.name) - \(location.cityName)")
                .font(.title2)
                .fontWeight(.bold)
            Text(location.address)
            Text(location.postcode)
        }
    }
    
    // Address, Postcode, Number, Email and Website
    private var moreInfoSection: some View {
        VStack(alignment: .leading, spacing: 10){
            
            Section(header: Text("Address")
                .font(.title3)
                .fontWeight(.bold)){
                    Text(location.address)}
            
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
            /**
             * The links below for Email and Website URL was reused from the article to allow redirection of the link when clicked.
             * Hudson, P.. (2021), Hacking with Swift - How to open web links in Safari. Link available at :  https://www.hackingwithswift.com/quick-start/swiftui/how-to-open-web-links-in-safari
             */
            Section(header: Text("Email")
                .font(.title3)
                    
                .fontWeight(.bold)) {
                    Link(destination: URL(string: "\(location.email)")!){
                        Text(location.email)
                    }
                }
            
            Section(header: Text("Website URL")
                .font(.title3)
                .fontWeight(.bold)) {
                    Link(destination: URL(string: "\(location.link)")!){
                        Text(location.link)
                    }
                }
        }
    }
    
    /**
     * Lines 132 and 133 were reused from the article to allow redirection of the link when clicked.
     * Hudson, P.. (2021), Hacking with Swift - How to open a URL in Safari. Link available at :  https://www.hackingwithswift.com/example-code/system/how-to-open-a-url-in-safari
     */
    private var websiteSection: some View {
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
    
    /**
     * Line 150 was reused from the YouTube video below to allows users to be redirected to the 'Maps' application for the current location clicked. T
     * Wells, C. (2023), A Swiftly Tilting Planet - How to Implement Map Integration in SwiftUI – Step by Step for Beginners (2023). Link available at :  https://www.youtube.com/watch?v=YVKuMJPGCj8&t=464s&ab_channel=ASwiftlyTiltingPlanet
     */
    private var directionsection: some View {
        //Button 3
        Button(action: {
            self.openMaps(coordinate: self.location.coordinates)
        }) {
            Label("Directions", systemImage: "car")
                .font(.headline)
                .frame(width: 138, height: 35)
        }
        .buttonStyle(.borderedProminent)
    }
    
    /**
     * The open maps function was reused from the YouTube video below to allows users to be redirected to the 'Maps' application for directions.
     * Wells, C. (2023), A Swiftly Tilting Planet - How to Implement Map Integration in SwiftUI – Step by Step for Beginners (2023). Link available at :  https://www.youtube.com/watch?v=YVKuMJPGCj8&t=464s&ab_channel=ASwiftlyTiltingPlanet
     */
    
    func openMaps(coordinate: CLLocationCoordinate2D){
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        mapItem.openInMaps()
    }
}


#Preview {
    LocationsPreviewView(location: LocationsData.locations.first!)
}

