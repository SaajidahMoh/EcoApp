//
//  AddItem.swift
//  EcoApp
//
//  Created by Saajidah Mohamed on 29/03/2024.
//

import SwiftUI
import Firebase

struct AddItem: View {
    // https://stackoverflow.com/questions/63927231/navigate-back-after-saving-in-swift-ui
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var name = ""
    @State private var quantity = 1
    @State private var expirydate = Date()
    @State private var description = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isPresented = false
    @State private var goBack  = false
    
    var userID: String? {
        return Auth.auth().currentUser?.uid }
    
    
    var body: some View {
        @StateObject var itemsViewModel = ItemsViewModel()
        
        // Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        NavigationView{
            Form {
                Section(header: Text("Ingredient name")) {
                    TextField("Item Name", text: $name)
                }
                
                Section(header: Text("Quantity")) {
                    Stepper("\(quantity)",
                            value: $quantity,in: 1...100)
                }
                
                Section(header: Text("Expiry Date")) {
                    DatePicker("Expiry Date", selection: $expirydate, displayedComponents: .date)
                }
                
                Section(header: Text("Description")) {
                    //VStack(alignment: .leading){
                    TextField("Description - Optional", text: $description)
                    //.frame(minHeight: 80)
                    //.frame(height: 40)
                        .multilineTextAlignment(.leading)
                    
                }
                
            }
            .accentColor(.red)
            .navigationTitle("Ingredient")
            .navigationBarItems(leading:
                                    Button("Cancel") {
                //isPresented = false
                //showEmailVerificationView = false
            }
                .foregroundColor(.green), trailing:
                                    Button("Save") {
                saveItem()
                
            } .foregroundColor(.green)
                .bold()
            
                    
            
            )
           

        
            
          /**  .toolbar {
                Button("  Save  "){
                }
                .foregroundColor(.green)
                .bold()
                
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
            } */
        }
        .alert(isPresented: $showAlert){
            Alert(title: Text("Alert"), message:Text(alertMessage), dismissButton: .default(Text("Ok")) {
                //isPresented = false
                self.presentationMode.wrappedValue.dismiss()
                itemsViewModel.fetchItemsAfterButton()
               
                    // goBack = true
            })

        }
        
    }
    func saveItem() {
        guard let userID = userID else {
            print("User not logged in")
            return
        }
        let db = Firestore.firestore()
        
        guard !name.isEmpty else {
            showAlert(message: "Please enter an item name.")
            return
        }
        
        let itemData : [String:Any] = [
            "id" : UUID().uuidString,
            "name": name,
            "quantity": quantity,
            "expirydate": expirydate,
            "description": description
        ]
       // db.collection("items").document(userID).collection("Item")
        //  let ref = db.collection("items").document(userID).collection("Item")
        db.collection("items").document(userID).collection("Item").addDocument(data:itemData) { error in
            if let error = error {
                showAlert(message: "Error saving :\(error.localizedDescription)")
            } else {
                showAlert(message: "Item saved.")
                name = ""
                quantity = 1
                expirydate = Date()
                description = ""
                //ListView()
                //isPresented = false
            }
        }
        
    }
    
        func showAlert(message:String){
            alertMessage = message
            showAlert = true
        
    }
}
                     

#Preview {
    AddItem()
}
