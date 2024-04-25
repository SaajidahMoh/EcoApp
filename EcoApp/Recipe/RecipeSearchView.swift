//
// RecipeSearchView.swift
//  EcoApp
//
//  Created by Saajidah Mohamed on 20/04/2024.
//
//
// https://www.youtube.com/watch?v=8CbUTZPPNT4&ab_channel=CredoAcademy GUI
import SwiftUI

enum sortCookingTime {
    case asc;
    case desc;
}
struct RecipeSearchView: View {
    @State private var isSaved : Bool = false
    let title: String
    let ingredients: [String]
    let cuisineTypes: [String]
    let image: String
    let totalTime: Float
    let url: String
    
  //  @State private var isSaved= false
   
    
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
                            /**.overlay(
                            Image(systemName: isSaved ? "star.fill" : "star")
                                        .resizable()
                                        .frame(width: 45, height: 45)
                                       // .foregroundColor(.darkGreen)
                                        .padding(5),
                            alignment: .bottomTrailing
                            ) */
                    } placeholder: {
                        ProgressView()
                    }
                    
                    Group {
                      //  HStack {
                            Text("\(title)")
                                .font(.system(.title))
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color (.systemGreen))
                                .padding(.top, 10)
                           /** Spacer()
                            
                            Image(systemName: isSaved ? "star.fill" : "star")
                                .resizable()
                                .frame(width: 28, height: 28)
                                .foregroundColor(.green)
                            // .foregroundColor(.darkGreen)
                                .padding(5)
                            
                        } */
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
                                
                                Button(action: shareRecipe
                                ){
                                    Image(systemName: "square.and.arrow.up")
                                        .resizable()
                                        .frame(width: 21, height: 30)
                                        .padding(10)
                                    //    .bold()
                                }
                            }
                        }
                        Text("Ingredients")
                            .fontWeight(.bold)
                            .font(.system(.title2))
                        
                        ForEach(ingredients, id: \.self) { ingredient in
                            VStack(alignment: .leading, spacing:6){
                                Spacer()
                                
                                //HStack {
                                //   Image(systemName: "star.fill")
                                //        .foregroundColor(.green)
                                //       .frame(width:10, height: 10)
                                Text(ingredient)
                                // .font(.subheadline)
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
      
    
    
    func shareRecipe() {
        // https://chat.openai.com/share/3b6d71c7-ab4b-4458-9a07-c11a5bf6a363
        /** guard let shareURL = URL(string: url) else { return }
         let activityViewController = UIActivityViewController(activityItems: [shareURL], applicationActivities: nil)
         UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil) */
        guard let window = UIApplication.shared.windows.first else { return }
        
        // Capture screenshot
        UIGraphicsBeginImageContextWithOptions(window.frame.size, false, 0.0)
        window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return }
        UIGraphicsEndImageContext()
        
        // Share screenshot
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
    }
}
    
     /**
#Preview {
    RecipeSearchView(title: "Egg Sandwich", ingredients: ["1 large Egg", "1 English Muffin", "1 ounce fontina fontal cheese"], cuisineTypes: ["American","British], image: "image_url", totalTime: 20.0, url: "https//www.marthastewart.com/1553018/baked-eggs")
 }
*/
