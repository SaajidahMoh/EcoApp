//
//  LocationMapAnnotationView.swift
//  EcoApp
//
//  Created by Saajidah Mohamed
//

/**
 * The locations map annotation view is the design of the locations pin. The code was reused from the video below, with adaptations of only the icon design and color.
 * Sarno, N. (2021), Swiftful Thinking - Custom Map Annotation Pins for SwiftUI MapKit Map | SwiftUI Map App #6. Link available at : https://www.youtube.com/watch?v=javFZbCYGfc&t=13s&ab_channel=SwiftfulThinking
 */

import SwiftUI
import MapKit

struct LocationMapAnnotationView: View {
    
    var body: some View {
        VStack(spacing: 0){
            // The pins icon
            Image(systemName: "mappin.circle")
                .resizable()
                .scaledToFit()
                .frame(width:30, height:30)
                .font(.headline) //little thicker
                .foregroundColor(.white)
                .padding(6)
                .background(.green)
                .cornerRadius(36)
            // The bottom part of the pin
            Image(systemName: "triangle.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(.green)
                .frame(width:10, height:10)
                .rotationEffect(Angle(degrees:180))
                .offset(y: -3)
                .padding(.bottom, 40)
        }
    }
}

/**
 * The code below was reused for the purpose to make the location pin more visible.
 * Sarno, N. (2021), Swiftful Thinking - Custom Map Annotation Pins for SwiftUI MapKit Map | SwiftUI Map App #6. Link available at : https://www.youtube.com/watch?v=javFZbCYGfc&t=13s&ab_channel=SwiftfulThinking
 */
#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        LocationMapAnnotationView()
    }
}
