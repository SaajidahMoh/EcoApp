//
//  ScannerView.swift
//  EcoApp
//
//  Created by Saajidah Mohamed on 29/03/2024.
// https://www.youtube.com/watch?v=6b2WAePdiqA&ab_channel=LoganKoshenka: Complete SwiftUI Firebase Tutorial: Auth, Sign Up Page, Cloud Firestore, Read & Write Data
// https://www.youtube.com/watch?v=m0QQ-hWs8fc&t=31s&ab_channel=SeanAllen

import SwiftUI
import Firebase

struct ScannerView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var barcode_string: String?
    @State private var foundProduct: Product?
    @State private var quantity = 1
    @State private var expiryDate = Date()
    @State private var description = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isPresented = false
    @State private var goBack  = false
    @State private var imageURL = ""
    
    //https://www.hackingwithswift.com/quick-start/swiftui/how-to-let-users-pick-options-from-a-menu
    @State private var selection = "Fridge"
    let place = ["Fridge", "Pantry", "Cupboard", "Cabinet", "Freezer"]
    
    var userID: String? {
        return Auth.auth().currentUser?.uid }
    
    
    
    var body: some View {
        @StateObject var itemsViewModel = ItemsViewModel()
        @State var name = foundProduct?.product.product_name ?? ""
        
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
                        }.sheet(isPresented: $isPresented) {
                            BarcodeScanning(barcode_string: $barcode_string, foundProduct:$foundProduct)
                        }
                    }
                }
                
                Section(header: Text("Quantity")) {
                    Stepper("\(quantity)",
                            value: $quantity,in: 1...100)
                }
                
                // https://www.hackingwithswift.com/forums/swiftui/help-with-onchange/24312 TimeStamp 00:00:00
                Section(header: Text("Expiry Date")) {
                    DatePicker("Expiry Date", selection: $expiryDate, displayedComponents: .date)
                        .onChange(of: expiryDate) { _, newValue in
                            let calendar = Calendar.current
                            let startOfDay = calendar.startOfDay(for: newValue)
                            expiryDate = startOfDay
                        }
                }
                
                //https://www.hackingwithswift.com/quick-start/swiftui/how-to-let-users-pick-options-from-a-menu
                Section(header: Text("Category")) {
                    //VStack(alignment: .leading){
                    //https://www.hackingwithswift.com/quick-start/swiftui/how-to-let-users-pick-options-from-a-menu
                    Picker("Select A Category", selection: $selection) {
                        ForEach(place, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
                    //  Text("Selected category: \(selection)")
                    //.frame(minHeight: 80)
                    //.frame(height: 40)
                    .multilineTextAlignment(.leading)
                    
                }
                
                Section(header: Text("Description")) {
                    //VStack(alignment: .leading){
                    TextField("Description - Optional", text: $description)
                    //.frame(minHeight: 80)
                    //.frame(height: 40)
                        .multilineTextAlignment(.leading)
                }
            }
            // .navigationBarItems(trailing:)
            .accentColor(.red)
            .navigationTitle("Ingredient")
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
                //isPresented = false
                self.presentationMode.wrappedValue.dismiss()
                itemsViewModel.fetchItemsAfterButton()
                //  self.persistImageToStorage() //copied LBTA
                
                // goBack = true
            })
        }
    }
    func saveItem() {
        @State var name = foundProduct?.product.product_name ?? ""
        
        guard let userID = userID else {
            print("User not logged in")
            return
        }
        
        let db = Firestore.firestore()
        
        guard !name.isEmpty else {
            showAlert(message: "Please enter an item name.")
            return
        }
        
        guard !selection.isEmpty else {
            showAlert(message: "Please select a category.")
            return
        }
        
        let itemData : [String:Any] = [
            "id" : UUID().uuidString,
            "name": name,
            "quantity": quantity,
            "expiryDate": expiryDate,
            "selection": selection,
            "description": description,
            "imageURL": imageURL,
        ]
        
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
                // image = nil
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
    ScannerView()
}
