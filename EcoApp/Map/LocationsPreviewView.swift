//
// LocationsPreviewView.swift
//  EcoApp
//
//  Created by Saajidah Mohamed on 20/04/2024.
//
//

import SwiftUI


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
                websiteSection
                emailSection
                callsection
            }
            if isSwiped == true {
                moreInfoSection
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
            
            Section(header: Text("Website URL")
                .font(.title3)
                .fontWeight(.bold)) {
                    Text(location.link)
                }
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

