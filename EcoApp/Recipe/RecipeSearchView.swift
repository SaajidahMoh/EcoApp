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
struct RecipeSearchView: View {
    let title: String
    let ingredients: [String]
    let cuisineTypes: [String]
    let image: String
    let totalTime: Float
    let url: String
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            
            //  "Failed to produce diagnostic for expression; please submit a bug report (https://swift.org/contributing/#reporting-bugs)"
            VStack(alignment: .center, spacing : 0){
                let photoURL = URL(string: image)
                AsyncImage(url: photoURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                    //.frame(width: 400.0, height: 260.0)
                    // .aspectRatio(contentMode: .fit)
                    //.ignoresSafeArea()
                } placeholder: {
                    ProgressView()
                }
                
                Group {
                    Text("\(title)")
                        .font(.system(.title))
                    // .font(.system(.largeTitle, design: .serif))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color (.systemGreen))
                    //.foregroundColor(Color("ColorGreenAdaptive"))
                        .padding(.top, 10)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                
                VStack(alignment: .leading){
                    HStack {
                        if totalTime > 0.01 {
                            Image(systemName: "clock.arrow.circlepath")
                            Text(": \(Int(round(totalTime))) mins")
                        }
                    }
                    HStack {
                        Image(systemName: "globe")
                        ForEach(cuisineTypes, id: \.self) { cuisineType in
                            let globe = cuisineType.capitalized
                            Text(": \(globe)")
                            
                            Spacer()
                            
                            Button(action: {}
                            ){
                                Image(systemName: "square.and.arrow.up")
                                    .resizable()
                                    .frame(width: 26, height: 35)
                                    .padding(10)
                                //    .bold()
                            }
                        }
                    }
                    Text("Ingredients")
                        .fontWeight(.bold)
                        .font(.system(.title2))
                    
                    ForEach(ingredients, id: \.self) { ingredient in
                        Text(ingredient)
                            .font(.subheadline)
                    }
                } .padding(.leading, 8)
                    .padding(.trailing, 8)
                
                VStack(alignment: .center, spacing: 0){
                            Spacer()
                    Text("")
                    Spacer()
                    Text ("")
                    Spacer()
                            Link(destination: URL(string: url)!) {
                                HStack {
                                    Image(systemName: "link")
                                    Text("View Recipe")
                                        .frame(width: 110, height: 40)
                                        .multilineTextAlignment(.center)
                                    
                                }  .multilineTextAlignment(.center)
                            }
                            .padding()
                            .buttonStyle(.borderedProminent)
                            
                            .multilineTextAlignment(.center)
                            
                        }
                
            }
        }
        .edgesIgnoringSafeArea(.top)
        
    }
} /**
   VStack(alignment: .leading){
   Text("\(title)")
   .font(.headline)
   .bold()
   
   Text("\(round(totalTime))")
   ForEach(ingredients, id: \.self) { ingredient in
   Text(ingredient)
   
   .font(.subheadline)
   
   }
   // https://sarunw.com/posts/how-to-capitalize-the-first-letter-in-swift/
   HStack {
   Text("Cuisine Type:")
   .bold()
   .foregroundColor(Color(.green))
   ForEach(cuisineTypes, id: \.self) { cuisineType in
   //  let cuisineType1 = cuisineType.prefix(1).capitalized
   //  let cuisineType2 = cuisineType.dropFirst().lowercased
   //  let cuisineType3 = cuisineType1 + cuisineType2
   // Text(cuisineType3)
   Text(cuisineType)
   
   }
   }
   Spacer()
   HStack(alignment: .center) {
   
   VStack {
   Link("Recipe Link", destination: URL(string: url)!)
   .padding()
   .buttonStyle(.borderedProminent)
   .padding(10)
   }
   Button(action: {}
   ){
   Image(systemName: "square.and.arrow.up")
   .padding(10)
   }
   
   
   }
   
   //  .alignment(.center)
   .padding()
   
   }
   }
   }
   } */

/**#Preview {
 RecipeSearchView()
 } */
