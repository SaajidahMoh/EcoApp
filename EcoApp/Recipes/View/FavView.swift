//
//  FavView.swift
//  EcoApp
//
//  Created by Saajidah Mohamed
//


import SwiftUI
import Firebase
import Kingfisher

struct RecipeListView: View {
    @State private var isSaved : Bool = true
    @ObservedObject var viewModel = FavViewModel() // Initialize the view model
    
    let userID: String? = Auth.auth().currentUser?.uid
    
    var body: some View {
        NavigationView {
            List(viewModel.recipes, id: \.label) { recipe in
                NavigationLink(destination: FavCardView(isSaved: true , title: recipe.label, ingredients: recipe.ingredientLines, cuisineTypes: recipe.cuisineType, image: recipe.image, totalTime: recipe.totalTime, url: recipe.url)) {
                    RecipeRowView(recipe: recipe)
                        .environmentObject(viewModel)
                }
                .buttonStyle(PlainButtonStyle())
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Favorites")
            .onAppear {
                viewModel.fetchFavs()
            }
            .background(Color(.systemGray5))
        }
    }
    
}

/**
 * The design of the recipe was reused and adapted to make the interface replicate my figma wireframe.
 * Petras, R. (2021). Let's Design the Recipe Cards with SwiftUI and Present all the Recipes - Part 12. Youtube video available at: https://www.youtube.com/watch?v=8CbUTZPPNT4&ab_channel=CredoAcademy
 */
struct RecipeRowView: View {
    @EnvironmentObject var viewModel : FavViewModel
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            /**
             * The image code was reused to display remote images in the app.
             * Moiseienko, M. (2023), SwiftUI: Efficient Image Loading using AsyncImage. Link available at: https://m-mois.medium.com/swiftui-efficient-image-loading-using-asyncimage-a059fe4efc34
             */
            let imageURL = URL(string: recipe.image)
            AsyncImage(url: imageURL) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 350, height: 120)
                    .clipped()
            } placeholder: {
                ProgressView()
            }
            
            HStack {
                Text(recipe.label)
                    .font(.headline)
                    .padding(.leading)
                    .padding(.vertical)
                
                Spacer()
                
                Button(action: {
                    viewModel.removeRecipe(recipe: recipe)
                })
                {
                    Image(systemName: "star.fill" )
                        .resizable()
                        .frame(width: 26, height: 26)
                }
                .padding(.trailing)
                .padding(.vertical)
            }
            .background(Color(.systemGray5))
        }
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray5))
    }
}



#Preview {
    RecipeListView()
}
