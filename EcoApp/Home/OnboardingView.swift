//
//  OnboardingView.swift
//  EcoApp
//
//  Created by Saajidah Mohamed
//

/**
 * The onboarding view initialises the information I want to share on my view page. It also allows users to swipe through the pages. The 'pages' array was adapted by me.
 * This code was reused from Youtube, Ayhan: SwiftUI Final Part - launch screenon boarding screen [https://www.youtube.com/watch?v=olV5wVf-tsE&ab_channel=Ayhan]
 * Jibrael, A. (2024), Ayhan - SwiftUI Final Part - launch screenon boarding screen. Link available at:  https://www.youtube.com/watch?v=olV5wVf-tsE&ab_channel=Ayhan
 */

import SwiftUI
// https://www.youtube.com/watch?v=olV5wVf-tsE&ab_channel=Ayhan
struct OnboardingView: View {
    
    @State private var currentPage: Int = 0
    @State private var showLogin: Bool = false
    
    // initialising the pages with my information
    let pages = [
        OnboardingPage(title: "A Global Issue", description: "Did you know that 60% of food waste around the world comes from households?", imageName: "fact"),
        OnboardingPage(title: "Welcome to EcoMake",  description: "Never let food go to waste! Be notified of expiring ingredients. Say goodbye to wasted food and hello to tasty recipes!", imageName: "meals"),
        OnboardingPage(title: "Make A Difference", description: "With EcoMake, you can find nearby food banks to donate unopened, unused ingredients.", imageName: "community")
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
                // allows users to interact and swipe through the pages.
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                // implements the page control view to let user see what page they're currently on
                PageControl(numberOfPages: pages.count, currentPage: $currentPage)
                    .padding(.vertical, 20)
            }
        }
    }
}

/**
 * The onboarding page view is the design of the pages.
 * This code's logic was reused from Youtube, Ayhan: SwiftUI Final Part - launch screenon boarding screen [https://www.youtube.com/watch?v=olV5wVf-tsE&ab_channel=Ayhan]. The code was adapted with another reuse stated below.
 * Jibrael, A. (2024), Ayhan - SwiftUI Final Part - launch screenon boarding screen https://www.youtube.com/watch?v=olV5wVf-tsE&ab_channel=Ayhan
 */

/**
 * The design of the VStack with the image, title and description, AND the button were reused from the Medium open Platform, Meet Patel.
 * Patel (2023), Create Beautiful Sliding OnBoarding Flow using App Storage and PageTabViewStyle in SwiftUI. Link available at:  https://medium.com/@meet237/create-beautiful-sliding-onboarding-flow-using-app-storage-and-pagetabviewstyle-in-swiftui-d733b84d6199
 */


struct OnboardingPage: View {
    @State private var showLogin: Bool = false
    
    var title: String
    var description: String
    var imageName: String
    
    var body: some View {
        VStack{
            VStack {
                // adjusts image
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .shadow(color: Color(red:0, green:0, blue: 0), radius: 3, x:2,y:2)
                // adjusts the title
                Text(title)
                    .fontWeight(.heavy)
                    .font(.system(size:32))
                // addjusts the description
                Text(description)
                    .fontWeight(.light)
                    .font(.system(size:18))
                    .padding(.bottom, 15)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                
                // Button implemented from Patel (2023).
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
            // Shows the Login page when button is clicked (show login is set to true)
            .fullScreenCover(isPresented: $showLogin) {
                Login()
            }
        }
        
    }
    
}

/**
 * The page control view shows the user what page they're on and fills the circle at the bottom according to the page.
 * This code was reused from Youtube, Ayhan: SwiftUI Final Part - launch screenon boarding screen [https://www.youtube.com/watch?v=olV5wVf-tsE&ab_channel=Ayhan]
 * Jibrael, A. (2024), Ayhan - SwiftUI Final Part - launch screenon boarding screen. Link available at:  https://www.youtube.com/watch?v=olV5wVf-tsE&ab_channel=Ayhan
 */

struct PageControl: View {
    var numberOfPages: Int
    @Binding var currentPage: Int
    
    var body: some View {
        HStack(spacing: 10) {
            // A circle for each of the page
            ForEach(0..<3) { page in
                Circle()
                    .frame(width: 8, height: 8)
                // current page = green, else gray
                    .foregroundColor(page == currentPage ? .green : .gray)
            }
        }
    }
}


#Preview {
    OnboardingView()
}


