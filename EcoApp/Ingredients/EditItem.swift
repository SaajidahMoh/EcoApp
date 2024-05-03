//
//  AddItem.swift
//  EcoApp
//
//  Created by Saajidah Mohamed
// 

import SwiftUI
import Firebase
import FirebaseStorage
import Kingfisher

struct EditItem: View {
    // https://stackoverflow.com/questions/63927231/navigate-back-after-saving-in-swift-ui
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var name = ""
    @State private var quantity = 1
    //@State private var expiryDate = Date()
    @State private var expiryDate = Date()
    @State private var description = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isPresented = false
    @State private var goBack  = false
    //@State private var imageURL = ""
    @State private var imageURL : URL?
    
    /**
     * The Picker was reused and adapted to allow users to keep track of where they are storing their ingredients.
     * Hudson, P. (2022), How to let users pick options from a menu. Published: Hacking With Swift. Available at: https://www.hackingwithswift.com/quick-start/swiftui/how-to-let-users-pick-options-from-a-menu
     */
    @State private var selection = ""
    let placeStored = ["Fridge", "Pantry", "Cupboard", "Cabinet", "Freezer", "Countertop", "Cellar", "Fruit Basket", "Kitchen Cart"]
    
    // Should show Image picker code reuse from: https://www.letsbuildthatapp.com/courses/SwiftUI-Firebase-Real-Time-Chat/Save-Images-to-Firebase-Storage
    @State var shouldShowImagePicker = false
    
    @State var image: UIImage?
    
    let item: Items
    
    var userID: String? {
        return Auth.auth().currentUser?.uid }
    
    
    var body: some View {
        @StateObject var itemsViewModel = ItemsViewModel()
        
        NavigationView{
            /**
             * The form was reused and adapted from a swiftui form video.
             * Allen, S. (2021), SwiftUI Form w/ TextField, DatePicker, Toggle, Stepper, Link and Sections w/ Header.
             * Youtube video available at: https://www.youtube.com/watch?v=m0QQ-hWs8fc&t=31s&ab_channel=SeanAllen
             */
            Form {
                /**
                 * The code relating to image and photo below has been reused and adapted from the video below. Aswell as the should show image picker and the image picker.
                 * Voong, B. (2021), SwiftUI Firebase Chat 03: Save Images to Firebase Storage.
                 * Youtube Link Available at: https://www.youtube.com/watch?v=5inXE5d2MUM&t=1056s&ab_channel=LetsBuildThatApp
                 * Source code Available at:  https://www.letsbuildthatapp.com/courses/SwiftUI-Firebase-Real-Time-Chat/Save-Images-to-Firebase-Storage
                 */
                
                if let image = self.image{
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 128, height: 128)
                }
                else if let imageURL = imageURL {
                    KFImage(imageURL)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 128, height: 128)
                    Button("Select Image"){
                        shouldShowImagePicker.toggle()
                    }
                    .foregroundColor(.green)
                    
                } else {Image(systemName: "photo")
                        .resizable()
                        .font(.system(size: 64))
                        .padding()
                        .foregroundColor(.gray)
                        .frame(height: 150)
                    Button("Select Image"){
                        shouldShowImagePicker.toggle()
                    }
                    .foregroundColor(.green)
                    
                    .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
                        ImagePicker(image: $image)
                    }
                    
                    .onAppear {
                        imageURL = URL(string: item.imageURL)
                    }
                }
                
                Section(header: Text("Ingredient name")) {
                    TextField("Item Name", text: $name)
                        .onAppear {
                            name = item.name
                        }
                }
                
                Section(header: Text("Quantity")) {
                    Stepper("\(quantity)",
                            value: $quantity,in: 1...100)
                    .onAppear {
                        quantity = item.quantity
                    }
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
                        .onAppear {
                            expiryDate = item.expiryDate.dateValue()
                        }
                }
                /**
                 * The Picker was reused and adapted to allow users to keep track of where they are storing their ingredients.
                 * Hudson, P. (2022), How to let users pick options from a menu. Published: Hacking With Swift. Available at: https://www.hackingwithswift.com/quick-start/swiftui/how-to-let-users-pick-options-from-a-menu
                 */
                Section(header: Text("Category")) {
                    Picker("Select A Cateogry", selection: $selection){
                        ForEach(placeStored, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
                    .onAppear {
                        selection = item.selection
                    }
                    .multilineTextAlignment(.leading)
                    
                }
                
                Section(header: Text("Description")) {
                    TextField("Description - Optional", text: $description)
                        .multilineTextAlignment(.leading)
                        .onAppear {
                            description = item.description
                        }
                }
            }
            .accentColor(.red)
            .navigationTitle("Ingredient")
            .navigationBarItems(leading:
                                    Button("Cancel") {
                self.presentationMode.wrappedValue.dismiss()
            }
                .foregroundColor(.green), trailing:
                                    Button("Update") {
                updateNewItem()
                
            } .foregroundColor(.green)
                .bold()
            )
        }
        .alert(isPresented: $showAlert){
            Alert(title: Text("Alert"), message:Text(alertMessage), dismissButton: .default(Text("Ok")) {
                self.presentationMode.wrappedValue.dismiss()
                itemsViewModel.fetchItemsAfterButton()
            })
        }
    }
    
   // the update new item function was reused and adapted to find the document of where the ID is stored and to replace it with the new data https://firebase.google.com/docs/firestore/query-data/queries
    func updateNewItem() {
        guard let userID = userID else {
            print("User not logged in")
            return
        }
        
        guard !name.isEmpty else {
            showAlert(message: "Please enter an item name.")
            return
        }
        
        let db = Firestore.firestore()
        let collectionRef = db.collection("items").document(userID).collection("Item")
        
        // code below was reused and developed to find the document of where the item is stored. https://peterfriese.dev/blog/2020/swiftui-firebase-fetch-data/
        collectionRef.whereField("id", isEqualTo: item.id).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents for item \(item.name): \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents found for item \(item.name)")
                return
            }
            
            if let document = documents.first {
                let documentID = document.documentID
                
                var updateData: [String:Any] = [
                    "id" : UUID().uuidString,
                    "name": name,
                    "quantity": quantity,
                    "expiryDate": expiryDate,
                    "description": description,
                    "selection": selection,
                    "imageURL": imageURL?.absoluteString ?? ""
                ]
                /**
                 * The code relating to image has been reused and adapted from the video below. Changes were made to the reference and store image to ensure the images didn't overwrite eachother with unique ID's.
                 * Voong, B. (2021), SwiftUI Firebase Chat 03: Save Images to Firebase Storage.
                 * Youtube Link Available at: https://www.youtube.com/watch?v=5inXE5d2MUM&t=1056s&ab_channel=LetsBuildThatApp
                 * Source code Available at:  https://www.letsbuildthatapp.com/courses/SwiftUI-Firebase-Real-Time-Chat/Save-Images-to-Firebase-Storage
                 */
                if let newImage = image {
                    let storeImage = UUID().uuidString
                    let ref = Storage.storage().reference(withPath: "images/\(userID)/\(storeImage).jpg")
                    
                    guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
                    
                    ref.putData(imageData, metadata: nil) { metadata, err in
                        if let err = err {
                            showAlert(message: "Failed to push image to Storage: \(err)")
                            return
                        }
                        
                        ref.downloadURL { url, err in
                            if let err = err {
                                showAlert(message: "Failed to retrieve downloadURL: \(err)")
                                return
                            }
                            guard let imageURLstring = url?.absoluteString else {
                                showAlert(message: "Unable to store image with url: \(url?.absoluteString ?? "")")
                                return
                            }
                            updateData["imageURL"] = imageURLstring
                            
                            // the code below was reused from Firebase to update the data https://firebase.google.com/docs/firestore/manage-data/add-data
                            collectionRef.document(documentID).setData(updateData, merge: true){ error in
                                if let error = error {
                                    print("Error updating item \(item.name): \(error.localizedDescription)")
                                } else {
                                    print("Item \(item.name) with id \(item.id) updated successfully.")
                                }
                            }
                        }
                    }
                } else {
                    // the code below was reused from Firebase to update the data https://firebase.google.com/docs/firestore/manage-data/add-data
                    collectionRef.document(documentID).setData(updateData, merge: true){ error in
                        if let error = error {
                            print("Error updating item \(item.name): \(error.localizedDescription)")
                        } else {
                            print("Item \(item.name) with id \(item.id) updated successfully.")
                        }
                    }
                }
            } else {
                print("\(item.name) failed to save")
            }
        }
    }
    
    
    func showAlert(message:String){
        alertMessage = message
        showAlert = true
        
    }
}
