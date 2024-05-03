//
//  ScannerView.swift
//  EcoApp
//
//  Created by Saajidah Mohamed 
// https://www.youtube.com/watch?v=6b2WAePdiqA&ab_channel=LoganKoshenka: Complete SwiftUI Firebase Tutorial: Auth, Sign Up Page, Cloud Firestore, Read & Write Data
// https://www.youtube.com/watch?v=m0QQ-hWs8fc&t=31s&ab_channel=SeanAllen

import SwiftUI
import Firebase

struct ScannerView: View {
    // Environemnt variable was reused from: https://stackoverflow.com/questions/63927231/navigate-back-after-saving-in-swift-ui
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var barcode_string: String? // code was reused from: https://www.youtube.com/watch?v=44APgBnapag&ab_channel=BrianAdvent
    @State private var foundProduct: Product? // code reused from https://www.youtube.com/watch?v=44APgBnapag&ab_channel=BrianAdvent
    @State private var quantity = 1
    @State private var expiryDate = Date()
    @State private var description = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isPresented = false
    @State private var goBack  = false
    @State private var imageURL = ""
    
    /**
     * The Picker was reused and adapted to allow users to keep track of where they are storing their ingredients.
     * Hudson, P. (2022), How to let users pick options from a menu. Published: Hacking With Swift. Available at: https://www.hackingwithswift.com/quick-start/swiftui/how-to-let-users-pick-options-from-a-menu
     */
    @State private var selection = "Fridge"
    let placeStored = ["Fridge", "Pantry", "Cupboard", "Cabinet", "Freezer", "Countertop", "Cellar", "Fruit Basket", "Kitchen Cart"]
    
    var userID: String? {
        return Auth.auth().currentUser?.uid }
    
    var body: some View {
        @StateObject var itemsViewModel = ItemsViewModel()
        
        // code was reused from: https://www.youtube.com/watch?v=44APgBnapag&ab_channel=BrianAdvent
        @State var name = foundProduct?.product.product_name ?? ""
        
        /**
         * The form was reused and adapted from a swiftui form video.
         * Allen, S. (2021), SwiftUI Form w/ TextField, DatePicker, Toggle, Stepper, Link and Sections w/ Header.
         * Youtube video available at: https://www.youtube.com/watch?v=m0QQ-hWs8fc&t=31s&ab_channel=SeanAllen
         */
        NavigationView{
            Form {
                Section(header: Text("Ingredient name")) {
                    HStack {
                        TextField("Item Name", text: $name)
                        Spacer()
                        Button(action: {
                            self.isPresented.toggle()
                        }) {
                            Image(systemName: "barcode")
                        }
                        
                        /**
                         * The code below was reused and adapted to present the scanner for items.
                         * Advent, B. (2020), Tutorial: Use APIs with Swift UI & Build a Book Barcode Scanner. YouTube video available at: https://www.youtube.com/watch?v=44APgBnapag&ab_channel=BrianAdvent
                         */
                        .sheet(isPresented: $isPresented) {
                            BarcodeScanning(barcode_string: $barcode_string, foundProduct:$foundProduct)
                        }
                    }
                }
                
                Section(header: Text("Quantity")) {
                    Stepper("\(quantity)",
                            value: $quantity,in: 1...100)
                }
                
                /** The forum linked below helped me solve the issue i had with setting the timestamp to 00:00:00 for accurate days difference for notifications.
                 Link available at: https://www.hackingwithswift.com/forums/swiftui/help-with-onchange/24312
                 */
                Section(header: Text("Expiry Date")) {
                    DatePicker("Expiry Date", selection: $expiryDate, displayedComponents: .date)
                        .onChange(of: expiryDate) { _, newValue in
                            let calendar = Calendar.current
                            let startOfDay = calendar.startOfDay(for: newValue)
                            expiryDate = startOfDay
                        }
                }
                /**
                 * The Picker was reused and adapted to allow users to keep track of where they are storing their ingredients.
                 * Hudson, P. (2022), How to let users pick options from a menu. Published: Hacking With Swift. Available at: https://www.hackingwithswift.com/quick-start/swiftui/how-to-let-users-pick-options-from-a-menu
                 */
                Section(header: Text("Category")) {
                    Picker("Select A Category", selection: $selection) {
                        ForEach(placeStored, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
                    .multilineTextAlignment(.leading)
                    
                }
                
                Section(header: Text("Description")) {
                    TextField("Description - Optional", text: $description)
                        .multilineTextAlignment(.leading)
                }
            }
            .accentColor(.red)
            .navigationTitle("Ingredient")
            // Environemnt dismiss was reused from: https://stackoverflow.com/questions/63927231/navigate-back-after-saving-in-swift-ui
            .navigationBarItems(leading:
                                    Button("Cancel") {
                self.presentationMode.wrappedValue.dismiss()
            }
                .foregroundColor(.green), trailing:
                                    Button("Save") {
                saveItem()
            } .foregroundColor(.green)
                .bold()
            )
        }
        
        .alert(isPresented: $showAlert){
            Alert(title: Text("Alert"), message:Text(alertMessage), dismissButton: .default(Text("Ok")) {
                // Environemnt dismiss was reused from: https://stackoverflow.com/questions/63927231/navigate-back-after-saving-in-swift-ui
                self.presentationMode.wrappedValue.dismiss()
                // fetches the items after completed.
                itemsViewModel.fetchItemsAfterButton()
            })
        }
    }
    
    func saveItem() {
        @State var name = foundProduct?.product.product_name ?? "" // code adapted and reused from https://www.youtube.com/watch?v=44APgBnapag&ab_channel=BrianAdvent
        
        guard let userID = userID else {
            print("User not logged in")
            return
        }
        
        guard !name.isEmpty else {
            showAlert(message: "Please enter an item name.")
            return
        }
        
        guard !selection.isEmpty else {
            showAlert(message: "Please select a category.")
            return
        }
        // code was adapted and reused from https://firebase.google.com/docs/firestore/manage-data/add-data
        let db = Firestore.firestore()
        
        let itemData : [String:Any] = [
            "id" : UUID().uuidString,
            "name": name,
            "quantity": quantity,
            "expiryDate": expiryDate,
            "selection": selection,
            "description": description,
            "imageURL": imageURL,
        ]
        // code was adapted and reused from https://firebase.google.com/docs/firestore/manage-data/add-data
        db.collection("items").document(userID).collection("Item").addDocument(data:itemData) { error in
            if let error = error {
                showAlert(message: "Error saving :\(error.localizedDescription)")
            } else {
                showAlert(message: "Item saved.")
                name = ""
                quantity = 1
                expiryDate = Date()
                selection = ""
                description = ""
                imageURL = ""
            }
            
        }
    }

    func showAlert(message:String){
        alertMessage = message
        showAlert = true
    
}
}

#Preview {
    ScannerView()
}
