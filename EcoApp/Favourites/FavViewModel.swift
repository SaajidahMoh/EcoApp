//
//  Fav ViewModel.swift
//  EcoApp
//
//  Created by Saajidah Mohamed 
// https://www.youtube.com/watch?v=6b2WAePdiqA&ab_channel=LoganKoshenka: Complete SwiftUI Firebase Tutorial: Auth, Sign Up Page, Cloud Firestore, Read & Write Data

import SwiftUI
import Firebase

class FavViewModel : ObservableObject{
    @Published var recipes: [Recipe] = []
    @State private var isSaved : Bool = false
    @EnvironmentObject var vieModel: FavViewModel
    
    var userID: String? {
        return Auth.auth().currentUser?.uid }
    
    init() {
        //fetchAllFavorites()
        Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
                    guard let self = self else { return }
                    
                    if let user = user {
                        print("User : \(user.uid)")
                        self.fetchFavs()
                    } else {
                        print("User is not logged in")
                        self.recipes.removeAll()
                    }
                }
    }

    
    func fetchFavs(){
        guard let userID = userID
        else {
            print("User not logged in")
            return
        }
        print("Fetching items for user \(userID)")
        
        recipes.removeAll()
        
        let db = Firestore.firestore()
        let ref = db.collection("favourites").document(userID).collection("Saved")
        
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
            self.recipes.removeAll()
            
            for document in snapshot.documents {
                let data = document.data()
                
                let imageURL = data["imageURL"] as? String ?? ""
                let label = data["label"] as? String ?? ""
                let totalTime = data["totalTime"] as? Float ?? 20
                let cuisineTypes = data["cuisineTypes"] as? [String] ?? []
                let ingredientLines = data["ingredients"] as? [String] ?? []
                let url = data["url"] as? String ?? ""
                
                let item = Recipe(label: label, image: imageURL, totalTime: totalTime, cuisineType: cuisineTypes, ingredientLines: ingredientLines, url: url) //isSaved : true)
                
                self.recipes.append(item)
            }
        }
    }
    
    func removeRecipe(recipe: Recipe){
        guard let userID = userID else {
            print("user not logged in")
            return
        }
        
        let db = Firestore.firestore()
        let favouritesRef = db.collection("favourites").document(userID).collection("Saved")
        
        favouritesRef.whereField("url", isEqualTo: recipe.url)
            .whereField("ingredients", isEqualTo: recipe.ingredientLines).getDocuments { (querySnapshot, error) in
                //.whereField("imageURL", isEqualTo: recipe.image)
                if let error = error {
                    print("Error getting documents for item : \(error.localizedDescription)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No documents found for item ")
                    return
                }
                
                if let document = documents.first {
                    let documentID = document.documentID
                    favouritesRef.document(documentID).delete { error in
                        if let error = error {
                            print("Error deleting: \(error.localizedDescription)")
                        } else {
                            print("deleted successfully.")
                        }
                        
                    }
                }
                else { print("none")
                }
            }
    }
}
