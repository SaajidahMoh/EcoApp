

import SwiftUI
import Firebase
import Kingfisher

struct RecipeListView: View {
    @State private var isSaved : Bool = true
    @ObservedObject var viewModel = FavViewModel() // Initialize the view model
    
    let userID: String? = Auth.auth().currentUser?.uid
    
    var body: some View {
        NavigationView {
            
            /** List(viewModel.recipes, id: \.label) { recipe in
                NavigationLink(destination: FavCardView(title: recipe.label, ingredients: recipe.ingredientLines, cuisineTypes:recipe.cuisineType, /**dietLabels: hit.recipe.dietLabels, */ image: recipe.image, totalTime: recipe.totalTime, url: recipe.url)) {
                    // FavView(recipe: recipe)
                } */
            
            List(viewModel.recipes, id: \.label) { recipe in
                VStack(alignment: .leading, spacing: 0) {
                     let imageURL = URL(string: recipe.image)
                         KFImage(imageURL)
                   // KFImage(URL(string: recipe.image))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 350 ,height: 120)
                        .clipped()
                
                    HStack {
                        Text(recipe.label)
                            .font(.headline)
                            .padding(.leading)
                            .padding(.vertical)
                        
                        
                        Spacer()
                        
                        
                        Button(action: {
                            /**  isSaved.toggle()
                             if !isSaved {
                             if let recipeToRemove = viewModel.recipes.first(where: { $0.label == recipe.label && $0.url == recipe.url }) {
                             removeRecipe(recipe: recipeToRemove)
                             }
                             } else {
                             print("stored")
                             }
                             }*/  //viewModel.toggleSavedState(for: recipe)
                            viewModel.removeRecipe(recipe:recipe)
                        }) {
                            Image(systemName: isSaved ? "star.fill" : "star")
                                .resizable()
                                .frame(width: 26, height: 26)
                        }

                    } .background(Color(.systemGray5))
                 //       .padding(.horizontal)
                } .background(Color(.systemGray5))
               //     .padding(.horizontal)
            }
            .navigationTitle("Favourites") // Set navigation title
            .onAppear {
                viewModel.fetchFavs() // Fetch recipes when view appears
            } //.background(Color(.systemGray5))
                .padding(.horizontal)
        }
       // .background(Color(.systemGray5))
        //.padding(.horizontal)
    }
    
    
}

#Preview {
    RecipeListView()
}
