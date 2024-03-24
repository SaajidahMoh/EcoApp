//
//  EcoAppApp.swift
//  EcoApp
//
//  Created by Saajidah Mohamed on 18/03/2024.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      // https://firebase.google.com/docs/firestore/quickstart#swift
    //let db = Firestore.firestore()

    return true
  }
}
@main
struct EcoAppApp: App {
    //init() {FirebaseApp.configure()}
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }
    }
}
