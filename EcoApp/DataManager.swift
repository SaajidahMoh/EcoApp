//
//  DataManager.swift
//  EcoApp
//
//  Created by Saajidah Mohamed on 24/03/2024.
//

import SwiftUI
import Firebase

class DataManager : ObservableObject{
    @AppStorage("log_status") private var logStatus: Bool = false
    @Published var items: [Items] = []
    
    //own code
    let userID: String? = Auth.auth().currentUser?.uid
    
    init() {
        fetchItems()
    }
    
    func fetchItems(){
        guard let userID = userID
        else {
            print("User not logged in")
            return
        }
        print(userID)
        
        items.removeAll() //empty
        
        let db = Firestore.firestore()
        let ref = db.collection("items").document(userID).collection("Item")
        //whereField("userID", isEqualTo: userID)
        // db.collection("users").document(result.user.uid).
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let snapshot = snapshot { //if empty
                for document in snapshot.documents {
                    let data = document.data()
                    let id = data["id"] as? String ?? ""
                    let name = data["name"] as? String ?? ""
                    
                    let item = Items(id: id, name: name)
                    self.items.append(item)
                }
            }
        }
    }

    /**func AddItems(itemName: String){
        let db = Firestore.firestore()
        let ref = db.collection("items").document(itemName)
        ref.setData(["name: itemName", "id" : 10] { error in
            if let error = error{
                print(error!.localizedDescription)
            }})
    } */
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
