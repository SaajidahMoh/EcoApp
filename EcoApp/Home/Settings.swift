//
//  Settings.swift
//  EcoApp
//
//  Created by Saajidah Mohamed
//

import Foundation
import SwiftUI
import Firebase
import UserNotifications

struct Settings: View {
    @AppStorage("log_status") private var logStatus: Bool = false
    @State private var email: String? = nil
    
    // Alerts
    @State private var showAlert = false
    @State private var showDeleteAlert = false
    @State private var showDeleteFav = false
    @State private var showDeleteIng = false
    @State private var showLogout = false
    @State private var showDeleteAcc = false
    @State private var alertMessage = ""
    
    // public variable userID that sets the user ID to be the current users ID.
    var userID: String? {
        return Auth.auth().currentUser?.uid }
    
    var body: some View {
        
        NavigationStack {
            VStack {
                Form {
                    // email field
                    Section(header: Text("Email")) {
                        if let userEmail = email {
                            Text(userEmail)
                        } else {
                            Text("..")
                        }
                    }
                    
                    Section(header: Text("Clear Ingredients"))
                    {
                        // clear all ingredients button which presents the alert
                        Button(action: {
                            showDeleteIng = true
                            print("printed")
                            
                        }) {
                            Text("Delete All Ingredients")
                        }
                        .foregroundColor(.red)
                    }
                    
                    /**
                     * Alert was reused and adapted from the 'hackingwithswift' website to perform actions on an alert, to confirm users want to delete their account.
                     * Hudson, P.  (2022), How to add actions to alert buttons . Link available at: https://www.hackingwithswift.com/quick-start/swiftui/how-to-add-actions-to-alert-buttons
                     */
                    
                    // Alert to confirm deleting saved ingredients
                    .alert(isPresented: $showDeleteIng){
                        Alert(title: Text( "Deleting All Ingredients"),
                              message: Text("Are you sure you want to do this?"),
                              primaryButton: .destructive(Text("Yes")){
                            clearIngredients()
                            showDeleteIng = false
                        }, secondaryButton: .cancel(Text("Cancel"))
                        )
                    }
                    
                    Section(header: Text("Clear Recipes")){
                        // clear saved recipes button which presents the alert
                        Button(action: {
                            showDeleteFav = true
                            
                        }) {
                            Text("Delete All Saved Recipes")
                        }.foregroundColor(.red)
                    }
                    
                    /**
                     * Alert was reused and adapted from the 'hackingwithswift' website to perform actions on an alert, to confirm users want to delete all their saved recipes.
                     * Hudson, P.  (2022), How to add actions to alert buttons . Link available at: https://www.hackingwithswift.com/quick-start/swiftui/how-to-add-actions-to-alert-buttons
                     * */
                    
                    // Alert to confirm deleting saved recipes
                    .alert(isPresented: $showDeleteFav){
                        Alert(title: Text( "Deleting All stored recipes"),
                              message: Text("Are you sure you want to do this?"),
                              primaryButton: .destructive(Text("Yes")){
                            clearSaved()
                            showDeleteFav = false
                        }, secondaryButton: .cancel(Text("Cancel"))
                        )
                    }
                    // fills the email field with the users email
                    .onAppear {
                        getUserEmail()
                    }
                }
                
                //logout button
                Button {
                    Logout()
                }    label : {
                    HStack {
                        Image(systemName: "arrow.down.right.and.arrow.up.left")
                        Text("LOGOUT")
                            .fontWeight(.bold)
                    }
                }
                // logout button style
                .buttonStyle(.bordered)
                .controlSize(.large)
                .multilineTextAlignment(.center)
                
                // Delete button which presents alert when clicked
                Button("Delete Account"){
                    showDeleteAcc = true
                }
                // delete button style
                .font(.headline)
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                
                .navigationTitle("Settings")
            }
            .background(Color(UIColor.systemGroupedBackground))
           
            /**
             * Alert was reused and adapted from the 'hackingwithswift' website to perform actions on an alert, to confirm users want to delete their account.
             * Hudson, P.  (2022), How to add actions to alert buttons . Link available at: https://www.hackingwithswift.com/quick-start/swiftui/how-to-add-actions-to-alert-buttons
             */
            
            // Alert to confirm to delete the account
            .alert(isPresented: $showDeleteAcc){
                Alert(title: Text( "Deleting your account"),
                      message: Text("Are you sure you want to delete your account?"),
                      primaryButton: .destructive(Text("Yes")){
                    // deletes users account from the authenticator
                    Auth.auth().currentUser?.delete()
                    showDeleteAcc = false
                    delUserEmail()
                }, secondaryButton: .cancel(Text("Cancel"))
                )
            }
        }
    }
    
    // functon to get the users email and displays it on the settings page
    func getUserEmail() {
        if let userID = Auth.auth().currentUser?.uid {
            let db = Firestore.firestore()
            let userRef = db.collection("users").document(userID)
            
            // gets the document where the users email is stored
            userRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    // if the document exists, get the email and store it in the variable email
                    if let userEmail = document.data()?["email"] as? String {
                        self.email = userEmail
                    } else {
                        print("Email not found in the users document")
                    }
                } else {
                    print("User not found")
                }
            }
        } else {
            print("No user is currently signed in")
        }
    }
    
    // function to delete the users email from the database
    func delUserEmail() {
        if let userID = Auth.auth().currentUser?.uid {
            let db = Firestore.firestore()
            let userRef = db.collection("users").document(userID)
            
            // finds the usersID and deletes it from the database
            userRef.delete { error in
                if let error = error {
                    print("Error deleting user email: \(error.localizedDescription)")
                } else {
                    print("user deleted")
                }
            }}
        // deletes all ingredients and recipes stored and logs the user out.
        clearIngredients()
        clearSaved()
        Logout()
    }
    
    // function to clear all saved ingredients from the database
    func clearIngredients(){
        if let userID = userID {
            let db = Firestore.firestore()
            let itemCollectionRef = db.collection("items").document(userID).collection("Item")
            // gets the document of where all of the users ingredients are stored
            itemCollectionRef.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents from Item collection: \(error.localizedDescription)")
                    return
                }
                // deletes all of the documents stored in the "Item"
                for document in querySnapshot!.documents {
                    document.reference.delete()
                }
                print("All items are cleared.")
                // removes all notiifcations
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                print("All notifications removed")
            }
        } else {
            print("No documents to clear")
        }
    }
    
    // function to clear all saved recipes
    func clearSaved(){
        if let userID = userID {
            let db = Firestore.firestore()
            let favCollectionRef = db.collection("favourites").document(userID).collection("Saved")
            favCollectionRef.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents from favourites: \(error.localizedDescription)")
                    return
                }
                for document in querySnapshot!.documents {
                    document.reference.delete()
                }
                print("All saved recipes are cleared.")
            }
        } else {
            print("No recipes were saved")
        }
    }
    
    // logout function
    // logs user out and removes all notifications from users device
    func Logout() {
        logStatus = false
        try? Auth.auth().signOut()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}

#Preview {
    Settings()
}


