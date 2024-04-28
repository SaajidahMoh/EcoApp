//
// LocationsMorePreView.swift
//  EcoApp
//
//  Created by Saajidah Mohamed on 20/04/2024.
//
//

import SwiftUI


/*
 code adapted from:
 https://xavier7t.com/swiftui-list-with-sort-options
 */
enum SortOption {
    case defaultTime, quickest, longest
}


struct recipeSearch: View {
    @State private var searchText: String = ""
    @State private var recipes: [Hit] = []
    @State private var isSaved : Bool = false
    @State private var isAscending = false
    @State private var selectedTheme = "Select Cuisine"
    var UniqueCuisineTypes: [String] = ["Select Cuisine","american", "asian", "british", "caribbean", "central europe", "chinese",  "eastern europe", "french", "greek",  "indian", "italian", "japanese", "korean", "kosher", "mediterranean", "mexican", "middle eastern", "nordic", "south american", "south east asian", "world" ]
    
    @State private var selectedDiet = "Select Diet"
    var dietTypes : [String] = ["Select Diet", "balanced", "high-protein", "high-fiber", "low-fat", "low-carb", "low-sodium"]
    
    
    /*
     code adapted from:
     https://xavier7t.com/swiftui-list-with-sort-options
     */
     @State private var sortOption: SortOption = .quickest
     var sortedTasks: [Hit] {
         var filteredData = [Hit]()
            if !selectedTheme.isEmpty {
                filteredData = recipes.filter { $0.recipe.cuisineType.contains(selectedTheme) }
            }; if selectedTheme == "Select Cuisine"{
                 filteredData = recipes
            }/**;  if !selectedDiet.isEmpty {
                filteredData = recipes.filter{ $0.recipe.dietLabels.contains(selectedDiet)}
                }; if selectedDiet == "Select Diet"{
                    filteredData = recipes
                }*/
                
         switch sortOption {
         case .defaultTime:
             return filteredData
         case .quickest:
             return filteredData.sorted { $0.recipe.totalTime < $1.recipe.totalTime }
         case .longest:
             return filteredData.sorted { $0.recipe.totalTime > $1.recipe.totalTime }
         }
     }
    
    var body: some View {
        VStack {
            if !isSearching() {
                HStack {
                    Picker("Options", selection: $selectedTheme) {
                        ForEach(UniqueCuisineTypes, id: \.self) { cuisineType in
                            Text(cuisineType).tag(cuisineType)
                        }
                    }.pickerStyle(.menu)
                    
                    /**  Picker("Select Diet", selection: $selectedDiet) {
                     ForEach(dietTypes, id: \.self) { dietLabels in
                     Text(dietLabels).tag(dietLabels)
                     }
                     }.pickerStyle(.menu) */
                    
                    Picker("Sort By", selection: $sortOption) {
                        Text("Default").tag(SortOption.defaultTime)
                        Text("Shortest Time").tag(SortOption.quickest)
                        Text("Longest Time").tag(SortOption.longest)
                    }.pickerStyle(.menu)
                }
            }
            
            /** Button() {
                
            } label: {
                Image(systemName: "arrow.up.arrow.down")
            } */
            
            NavigationView {
                List(sortedTasks, id: \.recipe.url) { hit in
                    NavigationLink(destination: RecipeSearchView(title: hit.recipe.label, ingredients: hit.recipe.ingredientLines, cuisineTypes: hit.recipe.cuisineType, /**dietLabels: hit.recipe.dietLabels, */ image: hit.recipe.image, totalTime: hit.recipe.totalTime, url: hit.recipe.url)) {
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
    
              
    func isSearching() -> Bool {
           // Check if the searchText is not empty, indicating the user is searching
           return !searchText.isEmpty
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


