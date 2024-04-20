//
//  LocationMapAnnotationView.swift
//  EcoApp
//
//  Created by Saajidah Mohamed on 20/04/2024.
//
//

import SwiftUI
import MapKit

struct LocationMapAnnotationView: View {
    
    let accentColor = Color(.green)
    var body: some View {
      //  Text("hello")
        VStack(spacing: 0){
            Image(systemName: "mappin.circle")
                .resizable()
               // .scaledToFill()
                .scaledToFit()
                .frame(width:30, height:30)
                .font(.headline) //little thicker
                .foregroundColor(.white)
                .padding(6)
                .background(accentColor)
                .cornerRadius(36)

            Image(systemName: "triangle.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(accentColor)
                .frame(width:10, height:10)
                .rotationEffect(Angle(degrees:180))
                .offset(y: -3)
                .padding(.bottom, 40)
                    }
        //.background(Color.blue)
    }
}


#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        LocationMapAnnotationView()
    }
}
