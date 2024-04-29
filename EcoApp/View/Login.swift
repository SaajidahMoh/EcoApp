//
//  Login.swift
//  EcoApp
//
//  Created by Saajidah Mohamed on 18/03/2024.
//
import Foundation
import Firebase
import FirebaseFirestore
import SwiftUI
import Lottie

struct Login: View {
    // View Properties
    @State private var activeTab: Tab = .login
    @State private var isLoading: Bool = false
    @State private var showEmailVerificationView: Bool = false
    @State private var emailAddress: String = ""
    @State private var password: String = ""
    @State private var reEnterPassword: String = ""
    
    //Alert Properties
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    
    //Forgot Password Properties
    @State private var showResetAlert: Bool = false
    @State private var resetEmailAddress: String = ""
    
    @AppStorage("log_status") private var logStatus: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    
                    TextField("Email Address", text: $emailAddress )
                        .keyboardType(.emailAddress)
                        .customTextField("person")
                    
                    SecureField("Password", text: $password )
                        .customTextField("person", 0, activeTab == .login ? 10: 0)
                    
                    if activeTab == .SignUp {
                        SecureField("Re-Enter Password", text: $reEnterPassword )
                            .customTextField("person", 0, activeTab != .login ? 10: 0)
                        
                    }
                }
                
            header: {
                Picker("", selection: $activeTab) {
                    ForEach(Tab.allCases, id:  \.rawValue) {
                        Text($0.rawValue)
                            .tag($0)
                    }
                    
                }
                .pickerStyle(.segmented)
                .listRowInsets(.init(top: 15, leading: 0, bottom: 0, trailing: 15))
                .listRowSeparator(.hidden)
                .padding(.bottom, 25) // mine
                
            }
       
            footer: {
                VStack(alignment: .trailing, spacing:12, content: {
                    if activeTab == .login {
                        Button("Forgot Password?"){
                            showResetAlert = true
                        }
                        .font(.caption)
                        .tint(Color.accentColor)
                        
                    }
                    Button(action: loginAndSignUp , label: {
                        HStack(spacing:12) {
                            Text(activeTab == .login ? "Login" : "Create Account")
                            
                            Image(systemName: "arrow.right")
                                .font(.callout)
                            
                        } .foregroundColor(.white)
                            .bold()
                            
                        // padding of width 16 on both sides. screen minus 16.
                       // .frame(width: UIScreen.main.bounds.width - 32, height:48 )
                        
                        
                        .frame(width: UIScreen.main.bounds.width - 60, height:48 )
                        .cornerRadius(10)
                       // .padding(.horizontal, 10)
                    })
                   // .padding(.top, 52)
                     // .background(Color(.systemGreen)
                      //  .cornerRadius(10))
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                    .showLoadingIndiciator(isLoading)
                    .disabled(buttonStatus)
                    
                })
                .frame(maxWidth:.infinity, alignment: .trailing)
                .listRowInsets(.init(top:15, leading:0, bottom: 0, trailing: 0))
            }
            .disabled(isLoading)
            }
            .animation(.snappy, value: activeTab)
            .listStyle(.insetGrouped)
            .navigationTitle("Welcome!")
        }
        .sheet(isPresented: $showEmailVerificationView, content: {
            EmailVerificationView()
                .presentationDetents([.height(350)])
                .presentationCornerRadius(25)
                .interactiveDismissDisabled()
            
            
        })
        .alert(alertMessage, isPresented: $showAlert) { }
        .alert("Rest Password", isPresented: $showResetAlert, actions: {
            TextField("Email Address", text: $resetEmailAddress)
            Button("Send Reset Link", role: .destructive, action: sendResetLink)
            Button("Cancel", role: .cancel){
                resetEmailAddress = ""
            }
        }, message :{
            Text("Enter the email address")
        })
        .onChange(of: activeTab, initial: false) {
            oldValue, newValue in
            password = ""
            reEnterPassword = ""
        }
    }
    
    //https://lottiefiles.com/animations/email-ghbRKruisg
    @ViewBuilder
    func EmailVerificationView() -> some View {
        VStack(spacing: 6){
            GeometryReader { _ in
                if let Bundle = Bundle.main.path(forResource:"LottieAnimationGreen", ofType: "json") {
                    LottieView {
                        await LottieAnimation.loadedFrom(url: URL(filePath: Bundle))
                    }
                    .playing(loopMode:.loop )
                }
            }
            Text ("Verification")
                .font(.title.bold())
            
            Text("We have sent a verification email to your email address. \n Please verify to continue")
                .multilineTextAlignment(.center)
                .font(.caption)
                .foregroundStyle(.gray)
                .padding(.horizontal, 25)
        }
        .overlay(alignment: .topTrailing, content:{ Button("Cancel"){
            showEmailVerificationView = false
            // Delete account in Firebase
            /** if let user = Auth.auth().currentUser{
             user.delete { _ in
             isLoading = false}
             } */
            
        } .padding(15)
            
        })
        .padding(.bottom, 15)
        /** })
         
         //Verify every 2 seconds to see if verified
         .onReceive(Timer.publish(every: 2, on: .main, in: .default).autoconnect(), perform : { _ in */
        .onReceive(Timer.publish(every: 2, on: .main, in: . default).autoconnect(),  perform: { _ in
            if let user = Auth.auth().currentUser {
                user.reload()
                if user.isEmailVerified {
                    showEmailVerificationView = false
                    logStatus = true
                    //Email succesfuful verified.
                }
            }
        })
    }
    
    func sendResetLink(){
        Task {
            do {
                if resetEmailAddress.isEmpty {
                    await presentAlert("Please enter an email address.")
                    return
                    
                }
                isLoading = true
                try await Auth.auth().sendPasswordReset(withEmail: resetEmailAddress)
                await presentAlert("Please check your email inbox and follow the steps to rest your password")
                
                resetEmailAddress = ""
                isLoading = false
            } catch {
                await presentAlert(error.localizedDescription)
            }
        }
    }
    
    func loginAndSignUp(){
        Task {
            isLoading = true
            do {
                if activeTab == .login {
                    // Logging in
                    let result = try await Auth.auth().signIn(withEmail: emailAddress, password: password)
                    if result.user.isEmailVerified {
                        // Verified User
                        // Redirect to Home View
                        logStatus = true
                    } else {
                        // Send Verificaiton Email
                        try await result.user.sendEmailVerification()
                        showEmailVerificationView = true
                    }
                } else {
                    //Creating New account
                    if password == reEnterPassword {
                        let result = try await Auth.auth().createUser(withEmail: emailAddress, password: password)
                        
                        let db = Firestore.firestore()
                                try await db.collection("users").document(result.user.uid).setData([
                                    "email": emailAddress])
                        
                        try await result.user.sendEmailVerification()
                        showEmailVerificationView = true
                    } else { await presentAlert("Mismatching Password")}
                }
            } catch {
                await presentAlert(error.localizedDescription)
                
            }
        }
        
    }
    
    // Presenting Alert
    func presentAlert(_ message: String) async {
        await MainActor.run {
            alertMessage = message
            showAlert = true
            isLoading = false
        }
    }
    
    
    //Tab Type
    enum Tab: String, CaseIterable {
        case login = "Login"
        case SignUp = "Sign Up"
    }
    
    //Button Status
    var buttonStatus: Bool {
        if activeTab == .login {
            return emailAddress.isEmpty || password.isEmpty
        }
        return emailAddress.isEmpty || password.isEmpty || reEnterPassword.isEmpty
    }
}

fileprivate extension View {
    @ViewBuilder
    func showLoadingIndiciator(_ status: Bool) -> some View {
        self
            .animation(.snappy){ content in
                content
                    .opacity(status ? 0: 1)
            }
            .overlay {
                if status {
                    ZStack {
                        Capsule()
                            .fill(.bar)
                        
                        ProgressView()
                    }
                }
            }
    
}
    
    @ViewBuilder
    func customTextField(_ icon: String? = nil, _ paddingTop: CGFloat = 0, _ paddingBottom: CGFloat = 0) -> some View {
        HStack(spacing: 12){
            if let icon {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(.gray)
            }
            self
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 12)
        .background(.bar, in:.rect(cornerRadius: 10))
        .padding(.horizontal, 15)
        .padding(.top, paddingTop)
        .padding(.bottom, paddingBottom)
        .listRowInsets(.init(top:10, leading:0, bottom: 0, trailing: 0))
        .listRowSeparator(.hidden)
    }
}

#Preview {
    ContentView()
    //Login()
}
