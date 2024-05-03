//
// RecipeCardView.swift
//  EcoApp
//
//  Created by Saajidah Mohamed on 20/04/2024.
//
//

import SwiftUI
import Firebase

/**
 * The design of the recipe was reused and adapted to make the interface replicate my figma wireframe.
 * Petras, R. (2021). Let's Design the Recipe Cards with SwiftUI and Present all the Recipes - Part 12. Youtube video available at: https://www.youtube.com/watch?v=8CbUTZPPNT4&ab_channel=CredoAcademy
 */
struct RecipeCardView : View {
    @State private var isSaved : Bool = false
    @ObservedObject var viewModel = FavViewModel()
    
    let hit: Hit
    let userID: String? = Auth.auth().currentUser?.uid
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            /**
             * The image code was reused to display remote images in the app.
             * Moiseienko, M. (2023), SwiftUI: Efficient Image Loading using AsyncImage. Link available at: https://m-mois.medium.com/swiftui-efficient-image-loading-using-asyncimage-a059fe4efc34
             */
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
                
                // saves/ removes recipe.
                Button(action: {
                    isSaved.toggle()
                    if isSaved == true
                    { storeRecipe()}
                    else { removeRecipe()
                    }
                })
                
                // fills the star if its saved
                {
                    Image(systemName: isSaved ? "star.fill" : "star")
                        .resizable()
                        .frame(width: 26, height: 26)
                }
                
                .padding(.trailing)
                .padding(.vertical)
            }
           
        }
        // shows the star
        .onAppear {
            checkStar()
        }
        
        .background(Color(.systemGray5))
        .padding(.horizontal)
        
    }
    
    // checks if the recipe is saved, if it is set it to true
   private func checkStar() {
        guard let userID = userID else {
            print("User not logged in")
            return
        }
        print("\(userID)")
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
                
                if !documents.isEmpty {
                    print("Recipe is saved")
                    isSaved = true
                } else {
                    print("Recipe is not saved")
                    isSaved = false
                }
            }
    }

    
    private func storeRecipe(){
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
                    print("Error checking if recipe exists: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No documents found")
                    return
                }
                
                if documents.isEmpty {
                    let favData: [String:Any] = [
                        "imageURL": hit.recipe.image,
                        "label": hit.recipe.label,
                        "totalTime": hit.recipe.totalTime,
                        "cuisineTypes": hit.recipe.cuisineType,
                        "ingredients": hit.recipe.ingredientLines,
                        "url": hit.recipe.url
                    ]
                    
                    favouritesRef.addDocument(data: favData) { error in
                        if let error = error {
                            print("Error saving recipe: \(error.localizedDescription)")
                        } else {
                            print("Recipe saved successfully!")
                        }
                    }
                } else {
                    print("Recipe is already saved!")
                }
            }
        isSaved = true
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
                        }
                    }
                }
                else { print("none")
                }
            }
    isSaved = false }}
    
