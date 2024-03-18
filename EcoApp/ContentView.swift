//
//  ContentView.swift
//  EcoApp
//
//  Created by Saajidah Mohamed on 18/03/2024.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @AppStorage("log_status") private var logStatus: Bool = false
    var body: some View {
        if logStatus {
            // Home
            Home()
        } else {
            Login()
        }
       /** VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding() */
        //Text("Hello, world!")
    }
}

#Preview {
    ContentView()
}
