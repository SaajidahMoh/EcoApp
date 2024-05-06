//
//  RecipeSearchView.swift
//  EcoApp
//
//  Created by Saajidah Mohamed
//

import SwiftUI
import UIKit

enum sortCookingTime {
    case asc;
    case desc;
}

struct RecipeSearchView: View {
    @State private var isSaved : Bool = false
    let title: String
    let ingredients: [String]
    let cuisineTypes: [String]
    //  let dietLabels: [String]
    let image: String
    let totalTime: Float
    let url: String
    
    /**
     * The design of the recipe was reused and adapted to make the interface replicate my figma wireframe.
     * Petras, R. (2021). Let's Design the Recipe Cards with SwiftUI and Present all the Recipes - Part 12. Youtube video available at: https://www.youtube.com/watch?v=8CbUTZPPNT4&ab_channel=CredoAcademy
     */
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            
            //  "Failed to produce diagnostic for expression; please submit a bug report (https://swift.org/contributing/#reporting-bugs)"
            Rectangle()
                .fill(Color.clear)
                .frame(height: 90)
            
            VStack(alignment: .center, spacing : 0){
                let photoURL = URL(string: image)
                AsyncImage(url: photoURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .clipped()
                } placeholder: {
                    ProgressView()
                }
                
                Group {
                    Text("\(title)")
                        .font(.system(.title))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color (.systemGreen))
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
                        // If there is more than one, present them together in a list.
                        if cuisineTypes.count > 1 {
                            let cuisineTypes2 = cuisineTypes.map{$0.capitalized}.joined(separator: ", ")
                            Text(cuisineTypes2)
                        } else { // show the first one as long as it's not empty.
                            Text(cuisineTypes.first?.capitalized ?? "")
                        }
                        
                        Spacer()
                        Button(action: shareRecipe
                        ){
                            Image(systemName: "square.and.arrow.up")
                                .resizable()
                                .frame(width: 21, height: 30)
                                .padding(10)
                        }
                        
                    }
                    Text("Ingredients")
                        .fontWeight(.bold)
                        .font(.system(.title2))
                    
                    ForEach(ingredients, id: \.self) { ingredient in
                        VStack(alignment: .leading, spacing:6){
                            Spacer()
                            
                            Text(ingredient)
                                .font(.system(size: 16))
                            Divider()
                        }
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
                                .frame(width: 150, height: 40)
                                .multilineTextAlignment(.center)
                                .font(.system(.title3))
                        }  .multilineTextAlignment(.center)
                    }
                    .padding()
                    .buttonStyle(.borderedProminent)
                    .multilineTextAlignment(.center)
                }
                
            } .padding(.leading)
                .padding(.trailing)
        }
        .edgesIgnoringSafeArea(.top)
    }
    
    // code was reused was chatgpt to allow screenshot of page, and sharing of the screenshot. https://chat.openai.com/share/75ea5027-cdf4-4dd8-b320-9f6173f65149
    func takeScreenshot() -> UIImage? {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
              let rootView = window.rootViewController?.view else {
            return nil
        }
        
        let renderer = UIGraphicsImageRenderer(size: rootView.bounds.size)
        let screenshot = renderer.image { context in
            rootView.drawHierarchy(in: rootView.bounds, afterScreenUpdates: true)
        }
        
        return screenshot
    }
    
    func shareRecipe() {
        if let screenshot = takeScreenshot() {
            let activityViewController = UIActivityViewController(activityItems: [screenshot], applicationActivities: nil)
            UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
        }
    }
}

/**
 #Preview {
 RecipeSearchView(title: "Egg Sandwich", ingredients: ["1 large Egg", "1 English Muffin", "1 ounce fontina fontal cheese"], cuisineTypes: ["American","British], image: "image_url", totalTime: 20.0, url: "https//www.marthastewart.com/1553018/baked-eggs")
 }
 */
