//
//  Home.swift
//  EcoApp
//
//  Created by Saajidah Mohamed on 18/03/2024.
//
import SwiftUI
// https://www.youtube.com/watch?v=olV5wVf-tsE&ab_channel=Ayhan
struct OnboardingView: View {
    
    @State private var currentPage: Int = 0
    @State private var showLogin: Bool = false
    
    let pages = [
        
       OnboardingPage(title: "A Global Issue", description: "Did you know that 60% of food waste around the world comes from households?", imageName: "fact"),
       OnboardingPage(title: "Welcome to EcoMake",  description: "Never let food go to waste! Be notified of expiring ingredients. Say goodbye to wasted food and hello to tasty recipes", imageName: "meals"),
       OnboardingPage(title: "Make A Difference", description: "With EcoMake, you can find nearby food banks to donate unopened, unused ingredients", imageName: "community")
   ]
    
    var body: some View {
        NavigationView {
            VStack {
                TabView(selection: $currentPage){
                    ForEach(0..<3) { index in
                        pages[index]
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                
                PageControl(numberOfPages: pages.count, currentPage: $currentPage)
                    .padding(.vertical, 20)
            }
        }
    }
}

struct OnboardingPage: View {
    @State private var showLogin: Bool = false

    var title: String
    var description: String
    var imageName: String
    
    var body: some View {
        VStack{
            /**ZStack(alignment: .topTrailing){
                Image("transparent")
                    .resizable()
                    .scaledToFit()
                    .frame(width:280, height: 45)
                    .padding()
                
                Spacer()
                // .padding()
            } */
                VStack {
                    // below design https://medium.com/@meet237/create-beautiful-sliding-onboarding-flow-using-app-storage-and-pagetabviewstyle-in-swiftui-d733b84d6199
                    Image(imageName)
                    //.resizable()
                    //.aspectRatio(contentMode: .fit)
                    //.frame(height: 330)
                        .resizable()
                        .scaledToFit()
                        .shadow(color: Color(red:0, green:0, blue: 0), radius: 3, x:2,y:2)
                    
                    Text(title)
                        .fontWeight(.heavy)
                        .font(.system(size:32))
                    //.font(Font.custom("Bebas Neue", size: 55))
                    // .bold()
                    //.padding(.bottom, 10)
                    
                    Text(description)
                        .fontWeight(.light)
                        .font(.system(size:18))
                        .padding(.bottom, 15)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                    //.multilineTextAlignment(.center)
                    // .foregroundColor(.gray)
                    
                    // Button: https://medium.com/@meet237/create-beautiful-sliding-onboarding-flow-using-app-storage-and-pagetabviewstyle-in-swiftui-d733b84d6199
                    
                    Button(action: {
                        showLogin = true
                    }) {
                        HStack {
                            Text("Let's get started")
                            Image(systemName: "arrow.forward.circle")
                        }
                        .padding(.horizontal, 25)
                        .padding(.vertical, 12)
                        .background(
                            Capsule().strokeBorder(lineWidth: 2)
                        )
                        .foregroundColor(.green)
                    }
                    .buttonStyle(.plain)
                    .accentColor(.green)
                    
                    
                }
                .padding(.horizontal, 15)
                
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .fullScreenCover(isPresented: $showLogin) {
                    Login() // Replace Login() with the actual view you want to present
                }
            }
        
        }
    
}

struct PageControl: View {
    var numberOfPages: Int
    @Binding var currentPage: Int
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<3) { page in
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundColor(page == currentPage ? .green : .gray)
            }
        }
    }
}


#Preview {
        OnboardingView()
    }

