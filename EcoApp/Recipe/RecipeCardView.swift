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
                        .frame(width: 20, height: 20)
                    
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
    
    private func storeRecipe(){
        guard let userID = userID else {
            print("user not logged in")
            return
        }
        
        let db = Firestore.firestore()
        let favouritesRef = db.collection("favourites").document(userID).collection("Saved")
        
        favouritesRef.addDocument (data:[
            "imageURL": hit.recipe.image,
            "label": hit.recipe.label,
            "totalTime": hit.recipe.totalTime,
            "cuisineTypes": hit.recipe.cuisineType,
            "ingredients": hit.recipe.ingredientLines,
            "url": hit.recipe.url]
                                   
        ) { error in
            if let error = error {
            print("Error Saving Recipe: \(error.localizedDescription)")
            } else {
                print("Saved!")
            }
            
        }
        
        
    }
    
    
    private func removeRecipe(){
        
    }
}


/**Preview {
   RecipeCardView()
}*/
