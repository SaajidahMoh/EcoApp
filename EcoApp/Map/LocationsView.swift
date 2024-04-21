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
    @StateObject var viewModel = ContentViewModel()
    
    
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
               // locationsPreviewStack
                if vm.showLocationsPreview{ //own code , ADDED THIS LINE
                    locationsPreviewStack
                }
                
            }
        }
    }
    private var mapLayer: some View {
        //Map(coordinateRegion: $vm.mapRegion)
        // anntoation item is the pin
        //annotation content is for each location, what do u want to put on the map?
        Map(coordinateRegion: viewModel.binding, showsUserLocation: true, userTrackingMode: .constant(.none), // userTrackingMode: .constant(.follow)
            annotationItems: vm.locations,
            annotationContent: { location in
            MapAnnotation(coordinate: location.coordinates) {
             //   Text("HI")
                LocationMapAnnotationView()
                    .scaleEffect(vm.mapLocation == location ? 1 : 0.7)
                    .shadow(radius:10)
                    .onTapGesture {
                       // vm.selectLocation(location)
                      //  locationsPreviewStack
                       // vm.showNextLocation(location: location)
                       
                     //   vm.isSwiped.toggle()
      //     ( location: location)
                       // vm.show
                        
                        //chat gpt
                        vm.toggleLocationPreview(location: location)
                    }

            }
            
           // MapMarker(coordinate: location.coordinates, tint: .blue)
        })
        .onAppear(perform: {
                            viewModel.checkIfLocationIsEnabled()
                        })
        
    }
    
    private var locationsPreviewStack: some View   {
        ForEach(vm.locations) { location in
                //shows preview only when tapped on the pin
           // if vm.mapLocation == location && vm.isSwiped == true{
            
            // chay gpt for this line
            if vm.mapLocation == location && vm.showLocationsPreview{
                LocationsPreviewView(location: location)
                    .shadow(color: Color.black.opacity(0.3),
                            radius: 20)
                    .padding()
                    .transition(.asymmetric(insertion: .move(edge:.trailing), removal: .move(edge:.leading)))
              
            }
        }
    }
    
}
// https://medium.com/@meet237/displaying-current-location-on-map-using-cllocationmanager-and-mapkit-in-swiftui-f42ea94391ed#:~:text=To%20display%20the%20map%20within,the%20showsUserLocation%20property%20to%20true%20.&text=MapKit%20provides%20a%20variety%20of,to%20improve%20the%20map%20experience.
// https://medium.com/@meet237/displaying-current-location-on-map-using-cllocationmanager-and-mapkit-in-swiftui-f42ea94391ed for user location
final class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?

    @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.52843913061934, longitude: -0.10237656930940268), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))

    var binding: Binding<MKCoordinateRegion> {
        Binding {
            self.mapRegion
        } set: { newRegion in
            self.mapRegion = newRegion
        }
    }

    func checkIfLocationIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.delegate = self
        } else {
            print("Show an alert letting them know this is off")
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let previousAuthorizationStatus = manager.authorizationStatus
        manager.requestWhenInUseAuthorization()
        if manager.authorizationStatus != previousAuthorizationStatus {
            checkLocationAuthorization()
        }
    }

    private func checkLocationAuthorization() {
        guard let location = locationManager else {
            return
        }

        switch location.authorizationStatus {
        case .notDetermined:
            print("Location authorization is not determined.")
        case .restricted:
            print("Location is restricted.")
        case .denied:
            print("Location permission denied.")
        case .authorizedAlways, .authorizedWhenInUse:
            if let location = location.location {
                mapRegion = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
            }

        default:
            break
        }
    }
}


/**
final class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
}*/


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
