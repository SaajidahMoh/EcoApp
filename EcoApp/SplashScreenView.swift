//
//  NewItemForm.swift
//  EcoApp
//
//  Created by Saajidah Mohamed on 01/04/2024.
//

import SwiftUI
// https://www.youtube.com/watch?v=0ytO3wCRKZU&t=197s&ab_channel=Indently SplashScreen

struct SplashScreenView: View {
    @State private var isActive = false //splashscreenactive
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        
        if isActive {
            ContentView()
        }  else {
            VStack {
                VStack{
                    Image("transparent")
                        .font(.system(size: 80))
                    
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.2)) {
                        self.size = 0.9 //slightly increase
                        self.opacity = 1.0 //fade in our logo as soon as it appear
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
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





