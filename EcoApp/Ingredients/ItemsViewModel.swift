//
//  ItemsViewModel.swift
//  EcoApp
//
//  Created by Saajidah Mohamed 
// 

import SwiftUI
import Firebase

/**
 * The view model was adapted to get the saved items
 * Koshenka, L. (2022), Complete SwiftUI Firebase Tutorial: Auth, Sign Up Page, Cloud Firestore, Read & Write Data. YouTube video available at: https://www.youtube.com/watch?v=6b2WAePdiqA&ab_channel=LoganKoshenka: Complete SwiftUI Firebase Tutorial: Auth, Sign Up Page, Cloud Firestore, Read & Write Data
 */

class ItemsViewModel : ObservableObject{
    @AppStorage("log_status") private var logStatus: Bool = false
    @Published var items: [Items] = []
    
    
    var userID: String? {
        return Auth.auth().currentUser?.uid }
    
    init() {
        
        // I implemented state change listener to check if the user is logged in or not.
        Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            guard let self = self else { return }
            
            if let user = user {
                print("User : \(user.uid)")
                self.fetchItems()
            } else {
                print("User is not logged in")
                self.items.removeAll()
            }
        }
    }
    
    
    /**
     * The function fetch items was  reused and adapted from the youtube video below to get the users items.
     * Koshenka, L. (2022) Complete SwiftUI Firebase Tutorial: Auth, Sign Up Page, Cloud Firestore, Read & Write Data.
     * YouTube Video Available At: https://www.youtube.com/watch?v=6b2WAePdiqA&ab_channel=LoganKoshenka
     */
    func fetchItems(){
        guard let userID = userID
        else {
            print("User not logged in")
            return
        }
        print("Fetching items for user \(userID)")
        
        // clear
        items.removeAll() //empty
        
        let db = Firestore.firestore()
        let ref = db.collection("items").document(userID).collection("Item")
        
        
        ref.addSnapshotListener { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print ("Error fetching items: \(error.localizedDescription)")
                return
            }
            
            guard let snapshot = snapshot else {
                print("Snapshot is empty")
                return
            }
            self.items.removeAll()
            
            /**
             * The code below for reading the data was reused and adapted from the youtube video below.
             * Koshenka, L. (2022) Complete SwiftUI Firebase Tutorial: Auth, Sign Up Page, Cloud Firestore, Read & Write Data.
             * YouTube Video Available At: https://www.youtube.com/watch?v=6b2WAePdiqA&ab_channel=LoganKoshenka
             */
            for document in snapshot.documents {
                let data = document.data()
                
                let id = data["id"] as? String ?? ""
                let name = data["name"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let quantity = data["quantity"] as? Int ?? 1
                let selection = data["selection"] as? String ?? ""
                let expiryDate = data["expiryDate"] as? Timestamp ?? Timestamp()
                let imageURL = data["imageURL"] as? String ?? ""
                
                let item = Items(id: id, name: name, isChecked: false, quantity:quantity, expiryDate: expiryDate, selection: selection, description: description,  imageURL: imageURL)
                self.items.append(item)
            }
            
        }
    }
    
    // finds the item and updates the status
    func updateItem(itemID: String, isChecked: Bool) {
        guard let index = items.firstIndex(where: { $0.id == itemID }) else { return }
        items[index].isChecked = isChecked
    }
    
    // acts as refresh
    func fetchItemsAfterButton(){
        items.removeAll()
        print("items removed")
        fetchItems()
        print("done")
    }
}

