//
//  EcoAppApp.swift
//  EcoApp
//
//  Created by Saajidah Mohamed
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import UserNotifications

// The code for the firebase configuration and app delegate was from the SDK setup and configuration, found in the Firebase Console.
// This can be found in the console, SDK Instructions - Step 4.  https://console.firebase.google.com/u/0/project/ecoapp-dafd1/settings/general/ios:disso.EcoApp22

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
    /**
     * The user notiifcation center funciton was reused to set local notiifcation on the mobile phone.
     * Kumar, V. (2023) Mastering Swift Local Notifications: A Developer’s Guide - Unlocking the Power of User Engagement with Swift’s Local Notification System. Published: Medium.
     * Link Available at : https://vikramios.medium.com/mastering-swift-local-notifications-a-developers-guide-f56b77ab64cc
     */
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
    
}
// The code for the firebase configuration and app delegate was from the SDK setup and configuration, found in the Firebase Console.
// This can be found in the console, SDK Instructions - Step 4.  https://console.firebase.google.com/u/0/project/ecoapp-dafd1/settings/general/ios:disso.EcoApp22
@main
struct EcoMakeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }
    }
}
