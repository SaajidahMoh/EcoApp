//
// RecipeCardView.swift
//  EcoApp
//
//  Created by Saajidah Mohamed on 20/04/2024.
//
//

import SwiftUI
import Firebase

struct RecipeCardView : View {
    @State private var isSaved : Bool = false
    let hit: Hit
    let userID: String? = Auth.auth().currentUser?.uid
    
    var body: some View {
        
        
        VStack(alignment: .leading, spacing: 0) {
            AsyncImage(url: URL(string: hit.recipe.image)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 350 ,height: 120)
            .clipped()
            
            HStack {
                Text(hit.recipe.label)
                    .font(.headline)
                    .padding(.leading)
                    .padding(.vertical)
                
                
                Spacer()
                
                
                Button(action: {
                    isSaved.toggle()
                    if isSaved == true
                    { storeRecipe() }
                    else { removeRecipe()}
                    //  else { storeRecipe}
                    
                })
                {
                    Image(systemName: isSaved ? "star.fill" : "star")
                        .resizable()
                        .frame(width: 26, height: 26)
                    
                }
                .onAppear {
                    loadSavedState()
                }
                .padding(.trailing)
                .padding(.vertical)
            }
        }
        // let lightest = Color(red: 0.4627, green: 0.8392, blue: 1.0)
        // .background(Color(UIColor.lightGray)) // https://stackoverflow.com/questions/59149705/how-to-set-the-background-color-of-a-swiftui-to-lightgray
        
        .background(Color(.systemGray5))
        .padding(.horizontal)
    }
    
    private func loadSavedState() {
            guard let userID = userID else {
                print("User not logged in")
                return
            }
            
            let db = Firestore.firestore()
            let favouritesRef = db.collection("favourites").document(userID).collection("Saved")
            
            favouritesRef.whereField("label", isEqualTo: hit.recipe.label)
                .whereField("url", isEqualTo: hit.recipe.url)
                .getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let documents = querySnapshot?.documents else {
                        print("No documents found")
                        return
                    }
                    
                    if let document = documents.first {
                        // Recipe found in Firestore, set isSaved to true
                        self.isSaved = true
                    }
                }
        }
    
    private func storeRecipe(){
        guard let userID = userID else {
            print("user not logged in")
            return
        }
        
        let db = Firestore.firestore()
        //let favouritesRef = db.collection("favourites").document(userID).collection("Saved")
        
        let favData : [String:Any] = [
       //     "id" : UUID().uuidString, //hit.recipe.id, //UUID().uuidString,
            "imageURL": hit.recipe.image,
            "label": hit.recipe.label,
            "totalTime": hit.recipe.totalTime,
            "cuisineTypes": hit.recipe.cuisineType,
            "ingredients": hit.recipe.ingredientLines,
            "url": hit.recipe.url
        ]
        
       // favouritesRef.addDocument
        db.collection("favourites").document(userID).collection("Saved").addDocument(data:favData) { error in
            if let error = error {
            print("Error Saving Recipe: \(error.localizedDescription)")
            } else {
                print("Saved!")
            }
            
        }
        
    }
    
    
    private func removeRecipe(){
        
        guard let userID = userID else {
            print("user not logged in")
            return
        }
        
        let db = Firestore.firestore()
        let favouritesRef = db.collection("favourites").document(userID).collection("Saved")
        
        favouritesRef.whereField("label", isEqualTo: hit.recipe.label)
            .whereField("url", isEqualTo: hit.recipe.url).getDocuments {(querySnapshot, error) in
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
                       // let favouritesRef = db.collection("favourites").document(userID).collection("Saved")
                   }
        
        
    }
}
            else { print("none")
            }
                             }}}
                             

/**Preview {
   RecipeCardView()
}*/
