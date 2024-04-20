//
// LocationsView.swift
//  EcoApp
//
//  Created by Saajidah Mohamed on 19/04/2024.
//https://www.youtube.com/watch?v=BKxbHnka4-Q&list=PLwvDm4Vfkdpha5eVTjLM0eRlJ7-yDDwBk&index=3&ab_channel=SwiftfulThinking

//https://www.youtube.com/watch?v=javFZbCYGfc&list=PLwvDm4Vfkdpha5eVTjLM0eRlJ7-yDDwBk&index=7&ab_channel=SwiftfulThinking

import SwiftUI
import MapKit
/**
class LocationsViewModel : ObservableObject {
    
    @Published var locations : [Location]
    
    init(){ //setting up locations
        let locations = LocationsDataService.locations
        self.locations = locations
    }
} */

struct LocationsView: View {
    // all views can access viewmodel
    //@StateObject private var vm = LocationsViewModel()
    @EnvironmentObject private var vm: LocationsViewModel
   /** @State private var mapRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.49888499999999, longitude: -0.138101), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)) */
    
    var body:some View {
       // Text("Hello")
        /** List {
            ForEach(vm.locations) {
                Text($0.name) //each location name
            }
                
        } */
        ZStack {
     mapLayer
            .ignoresSafeArea(edges: .top)
            
            
            VStack (spacing: 0){
                
                Spacer() //at bototm
                locationsPreviewStack
                
    
                
            }
        }
    }
    private var mapLayer: some View {
        //Map(coordinateRegion: $vm.mapRegion)
        // anntoation item is the pin
        //annotation content is for each location, what do u want to put on the map?
        Map(coordinateRegion: $vm.mapRegion,
            annotationItems: vm.locations,
            annotationContent: { location in
            MapAnnotation(coordinate: location.coordinates) {
             //   Text("HI")
                LocationMapAnnotationView()
                    .scaleEffect(vm.mapLocation == location ? 1 : 0.7)
                    .shadow(radius:10)
                
                    .onTapGesture {
                       // vm.selectLocation(location)
                        vm.showNextLocation(location: location)
      //     ( location: location)
                       // vm.show
                    }
            }
           // MapMarker(coordinate: location.coordinates, tint: .blue)
        })
        
    }
    
    private var locationsPreviewStack: some View   {
        ForEach(vm.locations) { location in
            if vm.mapLocation == location {
                LocationsPreviewView(location: location)
                    .shadow(color: Color.black.opacity(0.3),
                            radius: 20)
                    .padding()
                    .transition(.asymmetric(insertion: .move(edge:.trailing), removal: .move(edge:.leading)))
              
            }
        }
    }
    
}

/**struct MapView: View {
 // https://www.hackingwithswift.com/quick-start/swiftui/how-to-show-a-map-view
   // @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    var body: some View {
       // Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
     //   Map(coordinateRegion: $region)
      //             .frame(width: 400, height: 300)
        Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: .constant(.follow))
                  // .frame(width: 400, height: 300)
    }
}*/

#Preview {
    //MapView()
    LocationsView()
        .environmentObject(LocationsViewModel())
}
