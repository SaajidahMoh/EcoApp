//
//  ItemsViewModel.swift
//  EcoApp
//
//  Created by Saajidah Mohamed on 25/03/2024.
//https://www.youtube.com/watch?v=6b2WAePdiqA&ab_channel=LoganKoshenka: Complete SwiftUI Firebase Tutorial: Auth, Sign Up Page, Cloud Firestore, Read & Write Data

import SwiftUI
import Firebase

class ItemsViewModel : ObservableObject{
    @AppStorage("log_status") private var logStatus: Bool = false
    @Published var items: [Items] = []
    
    //own code
   // let userID: String? = Auth.auth().currentUser?.uid
    var userID: String? {
        return Auth.auth().currentUser?.uid }
    
    init() {
        //fetchItems()
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
    
         
    
    func fetchItems(){
        guard let userID = userID
        else {
            print("User not logged in")
            return
        }
        print("Fetching items for user \(userID)")
        
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
            
            for document in snapshot.documents {
                // print(document)
                let data = document.data()
                
                let id = data["id"] as? String ?? ""
                let name = data["name"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let quantity = data["quantity"] as? Int ?? 1
                let expiryDate = data["expiryDate"] as? Timestamp ?? Timestamp() //Date ?? Date()
                
                let item = Items(id: id, name: name, isChecked: false, quantity:quantity, description: description, expiryDate: expiryDate)
                self.items.append(item)
            }
            
            
            
        }
    }
    /**
        //whereField("userID", isEqualTo: userID)
        // db.collection("users").document(result.user.uid).
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
             
            if let snapshot = snapshot { //if empty
                for document in snapshot.documents {
                   // print(document)
                    let data = document.data()
                    
                    let id = data["id"] as? String ?? ""
                    let name = data["name"] as? String ?? ""
                    
                    let item = Items(id: id, name: name)
                    self.items.append(item)
                }
            }
            
        }
       
    } 
//chatgpt
     
     */
    //chat gpt
    func updateItem(itemID: String, isChecked: Bool) {
        guard let index = items.firstIndex(where: { $0.id == itemID }) else { return }
        items[index].isChecked = isChecked
    }

func fetchItemsAfterButton(){
        items.removeAll()
    print("items removed")
        fetchItems()
    print("done")
    }
}


/**
struct DataManager: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    DataManager()
}*/


