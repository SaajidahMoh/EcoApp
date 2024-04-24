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
    @State private var isSaved : Bool = false
    
    var body: some View {
        VStack {
            /** Button() {
                
            } label: {
                Image(systemName: "arrow.up.arrow.down")
            } */
            
            NavigationView {
                List(recipes, id: \.recipe.url) { hit in
                    NavigationLink(destination: PlayerView(title: hit.recipe.label, ingredients: hit.recipe.ingredientLines, cuisineTypes: hit.recipe.cuisineType, image: hit.recipe.image, totalTime: hit.recipe.totalTime, url: hit.recipe.url)) {
                        RecipeCardView(hit: hit)
                            .padding(.vertical, 2)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            // https://stackoverflow.com/questions/56614080/how-to-remove-the-left-and-right-padding-of-a-list-in-swiftui
                    .listStyle(PlainListStyle())
                   
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
    ContentView()
}


