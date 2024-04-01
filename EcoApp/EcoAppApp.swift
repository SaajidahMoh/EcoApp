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
import FirebaseStorage
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate{
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
//      let storage = Storage.storage()
      // https://firebase.google.com/docs/firestore/quickstart#swift
    //let db = Firestore.firestore()
      //self.storage = Storage.storage()
      
      UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                  if granted {
                      print("Notification authorization granted")
                      DispatchQueue.main.async {
                          application.registerForRemoteNotifications()
                      }
                  } else {
                      print("Notification authorization denied")
                  }
              }
              UNUserNotificationCenter.current().delegate = self

    return true
  }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
           let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
           print("Device Token: \(token)")
       }
    
       // https://vikramios.medium.com/mastering-swift-local-notifications-a-developers-guide-f56b77ab64cc
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
           completionHandler([.alert, .sound, .badge])
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
