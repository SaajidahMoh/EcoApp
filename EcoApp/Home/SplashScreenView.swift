//
//  SlapshScreenView.swift
//  EcoApp
//
//  Created by Saajidah Mohamed
//


/**
 * A view that shows my animated logo for when the app is opened and the user is not logged in.
 * This code was reused from Youtube channel "Indently" with video called : SplashScreen for iOS in SwiftUI Tutorial 2022 [https://www.youtube.com/watch?v=0ytO3wCRKZU&t=197s&ab_channel=Indently]
 * Federico (2022), Indently - SplashScreen for iOS in SwiftUI Tutorial 2022 (Xcode).  Link available at:  https://github.com/indently/SplashScreen/blob/main/SplashScreen/SplashScreenView.swift
 */

import SwiftUI

// REUSED
struct SplashScreenView: View {
    @State private var isActive = false //splashscreenactive
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        // when complete, redirects user to the onboarding view
        if isActive {
            OnboardingView()
        }  else {
            VStack {
                VStack{
                    // logo created by Saajidah Mohamed on Canva
                    Image("transparent")
                        .font(.system(size: 80))
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    // increases the size of the logo and fades it
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 0.9
                        self.opacity = 1.0
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                    withAnimation{
                        self.isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}





