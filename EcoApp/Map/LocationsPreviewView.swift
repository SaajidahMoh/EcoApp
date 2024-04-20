//
// LocationsPreviewView.swift
//  EcoApp
//
//  Created by Saajidah Mohamed on 20/04/2024.
//
//

import SwiftUI


struct LocationsPreviewView: View {
    
    let location: Location
    
    // https://www.youtube.com/watch?v=Ca0SisRHYuY&list=PLwvDm4Vfkdpha5eVTjLM0eRlJ7-yDDwBk&index=6&ab_channel=SwiftfulThinking
    
    var body: some View {
        
        VStack(spacing: 16) {
           titleSection
            
            HStack {
                websiteSection
                emailSection
                callsection
            }
           
        }
        .padding(25)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial))
        
            /**
            VStack(alignment: .leading, spacing: 4){
               // HStack{
                    Text("\(location.name) - \(location.cityName)")
                        .font(.title2)
                        .fontWeight(.bold)
                       // .font(.title3)
                //}
            Text(location.address)
                    //.font(.subheadline)
            Text(location.postcode)
            Text(location.phone)
               // Phone, extension,
                // Text(location.email)
             //   Text(location.link)
        }
    } */
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 4){

                Text("\(location.name) - \(location.cityName)")
                    .font(.title2)
                    .fontWeight(.bold)
        Text(location.address)
        Text(location.postcode)
        Text(location.phone)
    }
    }
    
    private var websiteSection: some View {
        Button {
        } label : {
            Text("Website")
                .font(.headline)
                .frame(width: 80, height: 35)
        }
        .buttonStyle(.borderedProminent)
      //  .background(.green)
       // .foregroundColor(.green)
        
    }
    
    private var emailSection: some View {
        
        //Button 2
        Button {
        } label : {
            Text("Email")
                .font(.headline)
                .frame(width: 80, height: 35)
        }
        .buttonStyle(.bordered)
        .foregroundColor(.green)
    }
    
    private var callsection: some View {
        //Button 3
        Button {
        } label : {
            Text("Call")
                .font(.headline)
                .frame(width: 80, height: 35)
        }
        .buttonStyle(.bordered)
        .foregroundColor(.green)
    }
}


#Preview {
    LocationsPreviewView(location: LocationsDataService.locations.first!)
}

