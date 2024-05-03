//
// LocationsMorePreView.swift
//  EcoApp
//
//  Created by Saajidah Mohamed on 20/04/2024.
//
//

import SwiftUI

/*
 * Enum sort option was adapted from the article below to implement filtering.
 * Xavier (2023), SwiftUI List with Sort Options. Published: iOS Devx. Link available at: https://xavier7t.com/swiftui-list-with-sort-options
 * Source code available at: https://github.com/xavier7t/iOSDevX/blob/main/iOSDevX/202303-Mar%202023/Sort%20Options/ContentView-DemoSortOptions20230320.swift
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
     * Sort option and sorted tasks were adapted from the article below to implement filtering.
     * Xavier (2023), SwiftUI List with Sort Options. Published: iOS Devx. Link available at: https://xavier7t.com/swiftui-list-with-sort-options
     * Source code available at: https://github.com/xavier7t/iOSDevX/blob/main/iOSDevX/202303-Mar%202023/Sort%20Options/ContentView-DemoSortOptions20230320.swift
     */
     @State private var sortOption: SortOption = .quickest
     var sortedTasks: [Hit] {
         var filteredData = [Hit]()
            if !selectedTheme.isEmpty {
                filteredData = recipes.filter { $0.recipe.cuisineType.contains(selectedTheme) }
            }; if selectedTheme == "Select Cuisine"{
                 filteredData = recipes
            }
         
         switch sortOption {
         case .defaultTime:
             return filteredData
         case .quickest:
             return filteredData.sorted { $0.recipe.totalTime < $1.recipe.totalTime }
         case .longest:
             return filteredData.sorted { $0.recipe.totalTime > $1.recipe.totalTime }
         }
     }
    
    /**
     *  The code showcasing the image, recipe name, total time, link to the instruction steps .. and the search was reused and adapted.
     *  codeAcademy (2023), Building Lists in SwiftUI Link avaliable at: https://www.codecademy.com/article/building-lists-in-swiftui
     *  Source code available at https://www.codecademy.com/resources/docs/swiftui/search
     */
    var body: some View {
        VStack {
            if !isSearching() {
                HStack {
                    Picker("Options", selection: $selectedTheme) {
                        ForEach(UniqueCuisineTypes, id: \.self) { cuisineType in
                            Text(cuisineType).tag(cuisineType)
                        }
                    }.pickerStyle(.menu)
                    
                    Picker("Sort By", selection: $sortOption) {
                        Text("Default").tag(SortOption.defaultTime)
                        Text("Shortest Time").tag(SortOption.quickest)
                        Text("Longest Time").tag(SortOption.longest)
                    }.pickerStyle(.menu)
                }
            }
            
            /**
             * The code was reused and developed to implement list and allow users to navigate when clicking.
             * Allen, S. (2021), SwiftUI List with Custom Cell & Passing Data. Link available at: https://www.youtube.com/watch?v=k5rupivxnMA&ab_channel=SeanAllen
             */
            NavigationView {
                List(sortedTasks, id: \.recipe.url) { hit in
                    NavigationLink(destination: RecipeSearchView(title: hit.recipe.label, ingredients: hit.recipe.ingredientLines, cuisineTypes: hit.recipe.cuisineType, image: hit.recipe.image, totalTime: hit.recipe.totalTime, url: hit.recipe.url)) {
                        RecipeCardView(hit: hit)
                            .padding(.vertical, 2)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listStyle(PlainListStyle())
                   
                }
                .navigationTitle("Recipes")
                .searchable(text: $searchText)
                
                // gets the new recipes when the search is changed
                .onChange(of: searchText) { _ in
                    getIngredients()
                }
                .onAppear {
                    getIngredients()
                }
            }
        }
    }
    
    // Check if the searchText is not empty - the user is searching
    func isSearching() -> Bool {
           return !searchText.isEmpty
       }
    
    //Update the recipes array with fetched data
    /**
     * The get ingredients function was reused and adapted to get the recipe name etc.. and stores the results into recipes.
     * Advent, B. (2020) iOS Swift Tutorial: Use APIs with Swift UI & Build a Book Barcode Scanner. Link available at: https://www.youtube.com/watch?v=44APgBnapag&ab_channel=BrianAdvent
     * Source code avaliable: https://www.patreon.com/posts/42828807
     */
    func getIngredients() {
        networkModel().sendRequest(searchTerm: searchText) { fetchedData in
            DispatchQueue.main.async {
                 recipes = fetchedData.hits
            }
        }
    }
    
}


#Preview {
  recipeSearch()
}


