//
// RecipeCardView.swift
//  EcoApp
//
//  Created by Saajidah Mohamed on 20/04/2024.
//
//

import SwiftUI

struct RecipeCardView : View {
    @State private var isSaved : Bool = false
    let hit: Hit
    
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
                            isSaved.toggle()})
                        {
                            Image(systemName: isSaved ? "star.fill" : "star")
                                .resizable()
                                .frame(width: 20, height: 20)
                        
                    }
                        .padding(.trailing)
                        .padding(.vertical)
                }
                }
                .background(Color.white)
                .padding(.horizontal)
            }
        }
        




/**Preview {
   RecipeCardView()
}*/
