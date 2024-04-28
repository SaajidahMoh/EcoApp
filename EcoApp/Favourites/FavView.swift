

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
              // https://stackoverflow.com/questions/56614080/how-to-remove-the-left-and-right-padding-of-a-list-in-swiftui
                      .listStyle(PlainListStyle())
                  }
                  .navigationTitle("Favorites")
                  .onAppear {
                      viewModel.fetchFavs() // Fetch recipes when view appears
                  }
                  .padding(.horizontal)
              }
          }
    
}

struct RecipeRowView: View {
    @EnvironmentObject var viewModel : FavViewModel
    let recipe: Recipe // Assuming you have a RecipeModel struct
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
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
                    // Toggle isSaved or store/remove recipe
                   // isSaved.toggle()
                   // if isSaved {
                        // Store recipe
                  //  } else {
                        // Remove recipe
                   // }
                }) {
                   // Image(systemName: isSaved ? "star.fill" : "star")
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
        .padding(.horizontal, 2)
       
    }
        
}



#Preview {
    RecipeListView()
}
