import SwiftUI

struct FavCardView: View {
 //   @State private var isSaved: Bool = false
    
    let isSaved: Bool
    let title: String
    let ingredients: [String]
    let cuisineTypes: [String]
    let image: String
    let totalTime: Float
    let url: String

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            Rectangle()
                .fill(Color.clear)
                .frame(height: 90)

            VStack(alignment: .center, spacing: 0) {
                let photoURL = URL(string: image)
                AsyncImage(url: photoURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .clipped()
                } placeholder: {
                    ProgressView()
                }

                Text("\(title)")
                    .font(.system(.title))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(.systemGreen))
                    .padding(.top, 10)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)

                VStack(alignment: .leading) {
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
                            Text("\(globe)")

                            Spacer()

                            // This is where you might want to fix the action
                            Button(action: {
                                shareRecipe()
                            }) {
                                Image(systemName: "square.and.arrow.up")
                                    .resizable()
                                    .frame(width: 21, height: 30)
                                    .padding(10)
                            }
                        }
                    }

                    Text("Ingredients")
                        .fontWeight(.bold)
                        .font(.system(.title2))

                    ForEach(ingredients, id: \.self) { ingredient in
                        VStack(alignment: .leading, spacing: 6) {
                            Spacer()
                            Text(ingredient)
                                .font(.system(size: 16))
                            Divider()
                        }
                    }
                }
                .padding(.horizontal, 8)

                VStack(alignment: .center, spacing: 0) {
                    Spacer()
                    Text("")
                    Spacer()
                    Text("")
                    Spacer()

                    Link(destination: URL(string: url)!) {
                        HStack {
                            Image(systemName: "link")
                            Text("View Recipe")
                                .frame(width: 150, height: 40)
                                .multilineTextAlignment(.center)
                                .font(.system(.title3))
                        }
                        .multilineTextAlignment(.center)
                    }
                    .padding()
                    .buttonStyle(.borderedProminent)
                    .multilineTextAlignment(.center)
                }
            }
            .padding(.horizontal)
        }
        .edgesIgnoringSafeArea(.top)
    }
    
    //RecipeSearchView
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
