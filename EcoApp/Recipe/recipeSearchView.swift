//
// LocationsMorePreView.swift
//  EcoApp
//
//  Created by Saajidah Mohamed on 20/04/2024.
//
//

import SwiftUI

enum sortCookingTime {
    case asc;
    case desc;
}
struct PlayerView: View {
    let title: String
    let ingredients: [String]
    let cuisineTypes: [String]
    let image: String
    let totalTime: Float
    let url: String

    var body: some View {
        VStack{
            let photoURL = URL(string: image)
             AsyncImage(url: photoURL) { image in
                         image
                             .resizable()
                             .frame(width: 200.0, height: 100.0)
                             .aspectRatio(contentMode: .fit)
                     } placeholder: {
                         ProgressView()
                     }
        }
        VStack{
            Text("\(title)")
            Text("\(round(totalTime))")
            ForEach(ingredients, id: \.self) { ingredient in
                Text(ingredient)
                
                    .font(.subheadline)
                
            }
            ForEach(cuisineTypes, id: \.self) { cuisineType in
                Text(cuisineType)
                
            }
            HStack {
                
                VStack {
                                Link("Recipe Link", destination: URL(string: url)!)
                            }
                            .padding()
//                Button("Recipe Link") {
//                    print("Button tapped!")
//
//                    //Text("\(url)")
//                }
                .buttonStyle(.borderedProminent)
            
                Image(systemName: "square.and.arrow.up")
                
                
            }
            
            .padding()
            
        }
    }
}

/**#Preview {
   PlayerView()
}*/
