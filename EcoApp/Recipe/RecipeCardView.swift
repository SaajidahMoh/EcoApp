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
    @ObservedObject var viewModel = FavViewModel()
    
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
                    { storeRecipe()}
                    else { removeRecipe()
                    }
                    
                    //  else { storeRecipe}
                })
                {
                    Image(systemName: isSaved ? "star.fill" : "star")
                        .resizable()
                        .frame(width: 26, height: 26)
                    
                }
              //  .onAppear {
                //    loadSavedState()
                    
                //}
                .padding(.trailing)
                .padding(.vertical)
              
            }
           
        }
        .onAppear {
            checkStar()
        }
        // let lightest = Color(red: 0.4627, green: 0.8392, blue: 1.0)
        // .background(Color(UIColor.lightGray)) // https://stackoverflow.com/questions/59149705/how-to-set-the-background-color-of-a-swiftui-to-lightgray
        
        .background(Color(.systemGray5))
        .padding(.horizontal)
        
    }
    
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
         //   .whereField("url", isEqualTo: hit.recipe.url)
           // .whereField("imageURL", isEqualTo: hit.recipe.image)
            //.whereField("ingredients", isEqualTo: hit.recipe.ingredientLines)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No documents found")
                    return
                }
                
              //  print("Documents count: \(documents.count)")
                
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
                            // let favouritesRef = db.collection("favourites").document(userID).collection("Saved")
                        }
                        
                        
                    }
                }
                else { print("none")
                }
            }
    isSaved = false }}
    
    
    /**Preview {
     RecipeCardView()
     }*/
