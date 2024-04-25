//
//  networkModel.swift
//  EcoApp
//
//  Created by Saajidah Mohamed on 14/04/2024.
//

import Foundation
import SwiftUI
import Firebase

struct SettingsView: View {
    @AppStorage("log_status") private var logStatus: Bool = false
    @State private var email: String? = nil
    @State private var showAlert = false
    @State private var showDeleteAlert = false
    @State private var showDeleteFav = false
 
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
                    
                    Section(header: Text("Clear Data"))
                    {
                        // clear all ingredients
                        Button(action: {
                            showDeleteAlert = true
                            
                        }) {
                            Text("Delete All Ingredients")
                        }.foregroundColor(.red)
                        
                        // clear saved recipes
                        /**  Button(action: {
                         showDeleteFav = true
                         
                         }) {
                         Text("Delete All Saved Recipes")
                         }.foregroundColor(.red) */
                        
                    }
                }
                    .onAppear {
                        getUserEmail()
                    }
                
                
                .alert(isPresented: $showDeleteAlert){
                    Alert(title: Text( "Deleting All ingredients"),
                          message: Text("Are you sure you want to do this?"),
                          primaryButton: .destructive(Text("Yes")){
                        clearIngredients()
                        showDeleteAlert = false
                    }, secondaryButton: .cancel(Text("Cancel"))
                    )

                }
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
                        
                        print("All items are cleared.")
                    }
                
            
        } else {
            print("No documents to clear")
        }

    }
    
        func showAlert(message:String){
            alertMessage = message
            showAlert = true
        
    }
}
/**
#Preview {
    SettingsView()
}
*/

