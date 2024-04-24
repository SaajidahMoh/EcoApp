//
// LocationsMorePreView.swift
//  EcoApp
//
//  Created by Saajidah Mohamed on 20/04/2024.
//
//

import SwiftUI

struct recipeSearch: View {
    @State private var searchText: String = ""
    @State private var recipes: [Hit] = []


    var body: some View {
        VStack {
            Button() {
                
            } label: {
                Image(systemName: "arrow.up.arrow.down")
            }
            NavigationView {
                List(recipes, id: \.recipe.url) { hit in
                    let photoURL = URL(string: hit.recipe.image)
                    AsyncImage(url: photoURL) { image in
                        image
                            .resizable()
                            .frame(width: 200.0, height: 100.0)
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                    NavigationLink(destination: PlayerView(title: hit.recipe.label, ingredients: hit.recipe.ingredientLines, cuisineTypes: hit.recipe.cuisineType, image: hit.recipe.image, totalTime: hit.recipe.totalTime, url: hit.recipe.url)) {
                        Text(hit.recipe.label)
                    }
                    
                    
                }
                .navigationTitle("Recipes")
                .searchable(text: $searchText)
                
                .onChange(of: searchText) { _ in
                    getIngredients()
                }
                .onAppear {
                    // Call getIngredients on initial appear
                    getIngredients()
                }
            }
        }
    }
    
              
    
    
    func getIngredients() {
        
        networkModel().sendRequest(searchTerm: searchText) { fetchedData in
            DispatchQueue.main.async {
                    // Update the recipes array with fetched data
                recipes = fetchedData.hits
                
            }
        }
    }

    
}


#Preview {
    recipeSearch()
}


