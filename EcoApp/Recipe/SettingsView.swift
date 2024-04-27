//
//  networkModel.swift
//  EcoApp
//
//  Created by Saajidah Mohamed on 14/04/2024.
//

import Foundation
import SwiftUI
import Firebase
import UserNotifications

struct SettingsView: View {
    @AppStorage("log_status") private var logStatus: Bool = false
    @State private var email: String? = nil
    @State private var showAlert = false
    @State private var showDeleteAlert = false
    @State private var showDeleteFav = false
    @State private var showDeleteIng = false
 
    @State private var showLogout = false
    @State private var showDeleteAcc = false
    
    @State private var alertMessage = ""
    
    var userID: String? {
        return Auth.auth().currentUser?.uid }
    
    var body: some View {
        
       /** let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            let email = user.email} */
        
        
        //Text("Hello, World!")
        NavigationStack {
            
            VStack {
                Form {
                    
                    Section(header: Text("Email")) {
                        if let userEmail = email {
                            Text(userEmail)
                        } else {
                            Text("..")
                        }
                        
                    }
                    
                    Section(header: Text("Clear Ingredients"))
                    {
                        // clear all ingredients
                        Button(action: {
                            // showDeleteAlert = true
                            //clearIngredients()
                            showDeleteIng = true
                            print("printed")
                            
                        }) {
                            Text("Delete All Ingredients")
                        }
                        .foregroundColor(.red)
                    }
                            .alert(isPresented: $showDeleteIng){
                                Alert(title: Text( "Deleting All Ingredients"),
                                      message: Text("Are you sure you want to do this?"),
                                      primaryButton: .destructive(Text("Yes")){
                                    clearIngredients()
                                    showDeleteIng = false
                                        //      UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                                    
                                }, secondaryButton: .cancel(Text("Cancel"))
                                )
                                
                            }
                    
                    Section(header: Text("Clear Recipes")){
    
                        // clear saved recipes
                        Button(action: {
                            showDeleteFav = true
                            
                        }) {
                            Text("Delete All Saved Recipes")
                        }.foregroundColor(.red)
                        
                    }
                  
                    .alert(isPresented: $showDeleteFav){
                        Alert(title: Text( "Deleting All stored recipes"),
                              message: Text("Are you sure you want to do this?"),
                              primaryButton: .destructive(Text("Yes")){
                            clearSaved()
                            showDeleteFav = false
                        }, secondaryButton: .cancel(Text("Cancel"))
                        )
                        
                    }
                    .onAppear {
                        getUserEmail()
                    }
                    
                }
                
                
            
                    //https://sarunw.com/posts/swiftui-button-size/
                    Button {
                        Logout()
                    }    label : {
                        HStack {
                            Image(systemName: "arrow.down.right.and.arrow.up.left")
                            Text("LOGOUT")
                                .fontWeight(.bold)
                        }
                    }
                    
                       // .frame(width: .infinity, height: 70)
                       // .frame(width: 138, height: 35)
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                        .multilineTextAlignment(.center)

                    // https://sarunw.com/posts/swiftui-button-size/
                    Button("Delete Account"){
                        showDeleteAcc = true
                       // UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                        
                    }    .font(.headline)
                        // .frame(width: 138, height: 35)
                        //.frame(width: .infinity, height: 70)
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)

                    //.onAppear {
                    //  getUserEmail()
                    //}
                    
                    /**Button("Logout"){
                     try? Auth.auth().signOut()
                     logStatus = false
                     
                     
                     }
                     .padding(.bottom, 10)
                     //.padding()*/
                    
                
                
                .navigationTitle("Settings")
            }
            .background(Color(UIColor.systemGroupedBackground))
            
       
            
            .alert(isPresented: $showDeleteAcc){
                Alert(title: Text( "Deleting your account"),
                      message: Text("Are you sure you want to delete your account?"),
                      primaryButton: .destructive(Text("Yes")){
                    Auth.auth().currentUser?.delete()
                    showDeleteAcc = false
                    delUserEmail()
                   // clearIngredients()
                    //clearSaved()
                  //  Logout()
                  //  showDeleteAcc = false
                }, secondaryButton: .cancel(Text("Cancel"))
                )

            }
            
            
        }
        
    }
    
    func getUserEmail() {
        if let userID = Auth.auth().currentUser?.uid {
            let db = Firestore.firestore()
            let userRef = db.collection("users").document(userID)
            
            userRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    if let userEmail = document.data()?["email"] as? String {
                        // Assign user's email to the @State variable
                       // self.email = userEmail
                       // DispatchQueue.main.async {
                            self.email = userEmail
                      //  }
                    } else {
                        print("Email field not found in user document")
                    }
                } else {
                    print("User document not found")
                }
            }
        } else {
            print("No user is currently signed in")
        }
    }
    
    func delUserEmail() {
        if let userID = Auth.auth().currentUser?.uid {
            let db = Firestore.firestore()
            let userRef = db.collection("users").document(userID)
            
            userRef.delete { error in
                if let error = error {
                    print("Error deleting user email: \(error.localizedDescription)")
                    
                } else {
                    print("user deleted")
                    
                }
            }}
        clearIngredients()
        clearSaved()
        Logout()
    }
                
                
                
     
    
    func clearIngredients(){
        if let userID = userID {
            let db = Firestore.firestore()
           // let usersRef = db.collection("users").document(userID)
            
            // Delete the user document
          //  usersRef.delete { error in
          //     if let error = error {
            //        print("Error deleting user document: \(error.localizedDescription)")
              //  } else {
                //    print("User document deleted successfully.")
                    
                    // delete the entire "Item" collection associated with the user
                    let itemCollectionRef = db.collection("items").document(userID).collection("Item")
                    itemCollectionRef.getDocuments { (querySnapshot, error) in
                        if let error = error {
                            print("Error getting documents from 'Item' collection: \(error.localizedDescription)")
                            return
                        }
                        
                        for document in querySnapshot!.documents {
                            document.reference.delete()
                        }
                           // UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                        
                        print("All items are cleared.")
                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                        print("notifs removed")
                    }
                
            
        } else {
            print("No documents to clear")
        }

    }
    
    func clearSaved(){
        if let userID = userID {
            let db = Firestore.firestore()
           // let usersRef = db.collection("users").document(userID)
            
            // Delete the user document
          //  usersRef.delete { error in
          //     if let error = error {
            //        print("Error deleting user document: \(error.localizedDescription)")
              //  } else {
                //    print("User document deleted successfully.")
                    
                    // delete the entire "Item" collection associated with the user
                    let itemCollectionRef = db.collection("favourites").document(userID).collection("Saved")
                    itemCollectionRef.getDocuments { (querySnapshot, error) in
                        if let error = error {
                            print("Error getting documents from 'Item' collection: \(error.localizedDescription)")
                            return
                        }
                        
                        for document in querySnapshot!.documents {
                            document.reference.delete()
                        }
                        
                        print("All favourites are cleared.")
                    }
                
            
        } else {
            print("No documents to clear")
        }

    }
    
    
    /**
     func showAlert(message:String){
         alertMessage = message
         showAlert = true
     
 }*/
    
    func Logout() {
        logStatus = false
        try? Auth.auth().signOut()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
/**
#Preview {
    SettingsView()
}
*/

