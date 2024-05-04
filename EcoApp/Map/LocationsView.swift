//
//  LocationsView.swift
//  EcoApp
//
//  Created by Saajidah Mohamed
//

import SwiftUI
import MapKit

/** The locations view was reused to show the map. There was the adaption to allow the locations information to show only when it's tapped. I
 * Sarno, N. (2021), Swiftful Thinking - Final review of MVVM Architecture and other features | SwiftUI Map App #9. Link available at :
 * https://www.youtube.com/watch?v=LuyWO86Myz0&ab_channel=SwiftfulThinking
 */
struct LocationsView: View {
    @EnvironmentObject private var vm: LocationsViewModel
    @StateObject var viewModel = ContentViewModel()
    
    var body:some View {
        ZStack {
            mapLayer
                .ignoresSafeArea(edges: .top)
            
            VStack (spacing: 0){
                // Developed the code to only display the information of the location when tapped.
                Spacer() // pushes the information towards the bottom of the screen
                if vm.showLocationsPreview{
                    locationsPreviewStack
                }
                
            }
        }
        .onAppear(perform: {
            viewModel.checkIfLocationIsEnabled()
        })
        // code reused and developed from https://stackoverflow.com/questions/62178494/is-there-an-equivalent-of-opensettingsurlstring-in-swiftui
        .alert(isPresented: $viewModel.locationDisabledAlert){
            Alert(
                title: Text ("Location Disabled"),
                message: Text("Location Services is off. Please turn it on in Settings"),
                primaryButton: .default(Text("Settings"), action: {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }),
                secondaryButton: .cancel()
            )
        }
        
    }
    /** The map layer below adapted from the video below to display the map and what is on the map. The code was adapted to implement user location and tracking, which the video did not show (and the on appear).
     * The code was also adapted to show the locations information only when tapped (the tap gesture).
     * Sarno, N. (2021), Swiftful Thinking - Final review of MVVM Architecture and other features | SwiftUI Map App #9. Link available at :
     * https://www.youtube.com/watch?v=LuyWO86Myz0&ab_channel=SwiftfulThinking
     */
    private var mapLayer: some View {
        // the tracking mode was set to none to allow users the option to roam around the map.
        Map(coordinateRegion: viewModel.binding, showsUserLocation: true, userTrackingMode: .constant(.none),
            annotationItems: vm.locations,
            annotationContent: { location in
            MapAnnotation(coordinate: location.coordinates) {
                LocationMapAnnotationView()
                    .scaleEffect(vm.mapLocation == location ? 1 : 0.7)
                    .shadow(radius:10)
                    .onTapGesture {
                        vm.toggleLocationPreview(location: location)
                    }
            }
        })
        /** .onAppear(perform: {
         viewModel.checkIfLocationIsEnabled()
         }) */
    }
    
    /** The locations preview stack was reused and adapted from the video below to only show for when the location preview is true (when tapped).
     * Sarno, N. (2021), Swiftful Thinking - Final review of MVVM Architecture and other features | SwiftUI Map App #9. Link available at :
     * https://www.youtube.com/watch?v=LuyWO86Myz0&ab_channel=SwiftfulThinking
     */
    
    private var locationsPreviewStack: some View   {
        ForEach(vm.locations) { location in
            // code was adapted and shows preview only when the pin is tapped.
            if vm.mapLocation == location && vm.showLocationsPreview {
                LocationsPreviewView(location: location)
                    .shadow(color: Color.black.opacity(0.3),
                            radius: 20)
                    .padding()
                    .transition(.asymmetric(insertion: .move(edge:.trailing), removal: .move(edge:.leading)))
            }
        }
    }
}

/** The ContentViewModel class below was reused from the article, Medium, to implement the user's location and the tracking.
 * Patel, M. (2023), Displaying current location on Map using CoreLocation and MapKit in SwiftUI. Published: Medium.  Link available at : https://medium.com/@meet237/displaying-current-location-on-map-using-cllocationmanager-and-mapkit-in-swiftui-f42ea94391ed
 */
final class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    
    @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.52843913061934, longitude: -0.10237656930940268), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    @Published var locationDisabledAlert = false
    
    var binding: Binding<MKCoordinateRegion> {
        Binding {
            self.mapRegion
        } set: { newRegion in
            self.mapRegion = newRegion
        }
    }
    // adapted to implemenet an alert and checking its not denied 
    func checkIfLocationIsEnabled() {
        print ("Checking if enabled")
        // as long as it is not denied, it will show the users current location
        if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() != .denied {
            locationManager = CLLocationManager()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.delegate = self
        } else {
            locationDisabledAlert = true
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


#Preview {
    LocationsView()
        .environmentObject(LocationsViewModel())
}
