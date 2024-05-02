//
//  Login.swift
//  EcoApp
//
//  Created by Saajidah Mohamed
//

/**
 * I followed the youtube video and reused the code to develop my login page to connect to the firebase, set up email authentication and the forgot password feature.
 * Minor adjustments were made to fix the interface of the login view. Adapted the login and sign up button and implemented padding bottom to place spacing between the picker, form and button.
 * The code was reused from YouTube, Kavsoft - Minimal Login Setup With Firebase Email Authentication - iOS 17 - Xcode 15. [https://www.youtube.com/watch?v=fC6_sm3y1vM&ab_channel=Kavsoft]
 * Venkatesh, B. (2024), Minimal Login Setup With Firebase Email Authentication - iOS 17 - Xcode 15. Link to source code available at: https://www.patreon.com/posts/early-access-ios-99594460
 */

import Foundation
import Firebase
import FirebaseFirestore
import SwiftUI
import Lottie

struct Login: View { // REUSE AND ADAPTED
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
                // Fields for the Login and sign up functionality: REUSED
                Section {
                    TextField("Email Address", text: $emailAddress )
                        .keyboardType(.emailAddress)
                        .customTextField("person")
                    
                    SecureField("Password", text: $password )
                        .customTextField("person", 0, activeTab == .login ? 10: 0)
                    // extra field for password when on the sign up page
                    if activeTab == .SignUp {
                        SecureField("Re-Enter Password", text: $reEnterPassword )
                            .customTextField("person", 0, activeTab != .login ? 10: 0)
                    }
                }
                
                // Picker's layout for login and sign up: REUSED
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
                .padding(.bottom, 25) //ADAPTED
            }
                
                // forgot password button: REUSED
            footer: {
                VStack(alignment: .trailing, spacing:12, content: {
                    if activeTab == .login {
                        Button("Forgot Password?"){
                            showResetAlert = true
                        }
                        .font(.caption)
                        .tint(Color.accentColor)
                    }
                    // login and sign up button
                    Button(action: loginAndSignUp , label: {
                        HStack(spacing:12) {
                            Text(activeTab == .login ? "Login" : "Create Account")
                            Image(systemName: "arrow.right")
                                .font(.callout)
                        }
                        .foregroundColor(.white)
                        .bold()
                        
                        // enlarged button with padding of width 30 on both sides.
                        // ADAPTED
                        .frame(width: UIScreen.main.bounds.width - 60, height:48 )
                        .cornerRadius(10)
                    })
                    // button style: ADAPTED
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                    .showLoadingIndiciator(isLoading)
                    // button is disabled unless fields are filled
                    .disabled(buttonStatus)
                    
                })
                .frame(maxWidth:.infinity, alignment: .trailing)
                .listRowInsets(.init(top:15, leading:0, bottom: 0, trailing: 0))
            }
            .disabled(isLoading)
            }
            // smooth transition for the picker
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
        // reset password alert.
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
        // when picker is changed (login or sign up), it clears the data inputted in the password
        .onChange(of: activeTab, initial: false) {
            oldValue, newValue in
            password = ""
            reEnterPassword = ""
        }
    }
    
    /**
     * The lottie file "LottieAnimationGreen" was reused from LottieFiles and was customised to change the colour to green for the pupose of my 'earth' and 'sustainability' theme.
     * Gajjar, J. (2024), Email. Place of publication: LottieFiles. Link available at: https://lottiefiles.com/animations/email-ghbRKruisg
     */
    
    //Email verification function: REUSE
    @ViewBuilder
    func EmailVerificationView() -> some View {
        VStack(spacing: 6){
            //displays lottie file as a loop until email is verified
            GeometryReader { _ in
                if let Bundle = Bundle.main.path(forResource:"LottieAnimationGreen", ofType: "json") {
                    LottieView {
                        await LottieAnimation.loadedFrom(url: URL(filePath: Bundle))
                    }
                    .playing(loopMode:.loop )
                }
            }
            // Text below the email animation
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
        } .padding(15)
            
        })
        .padding(.bottom, 15) //bottom padding
        
        // refreshes every 2 seconds to see if the user is verified
        .onReceive(Timer.publish(every: 2, on: .main, in: . default).autoconnect(),  perform: { _ in
            if let user = Auth.auth().currentUser {
                user.reload()
                // if user verifies email, sets logStatus to true and goes to the home page
                if user.isEmailVerified {
                    showEmailVerificationView = false
                    logStatus = true
                }
            }
        })
    }
    
    // reset password function: REUSE
    func sendResetLink(){
        Task {
            // prompts user to enter email address
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
    
    //login and signup function: REUSE
    func loginAndSignUp(){
        Task {
            isLoading = true
            do {
                if activeTab == .login {
                    // Logging in
                    let result = try await Auth.auth().signIn(withEmail: emailAddress, password: password)
                    if result.user.isEmailVerified {
                        logStatus = true
                    } else {
                        try await result.user.sendEmailVerification()
                        showEmailVerificationView = true
                    }
                } else {
                    // Creating new account if password matches
                    if password == reEnterPassword {
                        let result = try await Auth.auth().createUser(withEmail: emailAddress, password: password)
                        // conencts to the database
                        let db = Firestore.firestore()
                        try await db.collection("users").document(result.user.uid).setData([
                            "email": emailAddress])
                        
                        // sends email
                        try await result.user.sendEmailVerification()
                        showEmailVerificationView = true
                    } else { await presentAlert("Mismatching Password")}
                }
            } catch {
                await presentAlert(error.localizedDescription)
            }
        }
    }
    
    // Presents the Alert: REUSE
    func presentAlert(_ message: String) async {
        await MainActor.run {
            alertMessage = message
            showAlert = true
            isLoading = false
        }
    }
    
    //enum tab for login and sign up: REUSE
    enum Tab: String, CaseIterable {
        case login = "Login"
        case SignUp = "Sign Up"
    }
    
    //Button Status: REUSE
    var buttonStatus: Bool {
        if activeTab == .login {
            return emailAddress.isEmpty || password.isEmpty
        }
        return emailAddress.isEmpty || password.isEmpty || reEnterPassword.isEmpty
    }
}
//loading: REUSE
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
    
    /**
     * I followed the youtube video and reused the customTextField code to develop my login page.
     * The code was reused from YouTube, Kavsoft - Minimal Login Setup With Firebase Email Authentication - iOS 17 - Xcode 15. [https://www.youtube.com/watch?v=fC6_sm3y1vM&ab_channel=Kavsoft]
     * Venkatesh, B. (2024), Minimal Login Setup With Firebase Email Authentication - iOS 17 - Xcode 15. Link to source code available at: https://www.patreon.com/posts/early-access-ios-99594460
     */
    
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
}
