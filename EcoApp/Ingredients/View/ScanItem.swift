//
//  ScanItem.swift
//  EcoApp
//
//  Created by Saajidah Mohamed
// https://www.youtube.com/watch?v=6b2WAePdiqA&ab_channel=LoganKoshenka: Complete SwiftUI Firebase Tutorial: Auth, Sign Up Page, Cloud Firestore, Read & Write Data
// https://www.youtube.com/watch?v=m0QQ-hWs8fc&t=31s&ab_channel=SeanAllen

import SwiftUI
import Firebase
import FirebaseStorage

struct ScanItem: View {
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
    @State private var imageURL = ""
    
    /**
     * The Picker was reused and adapted to allow users to keep track of where they are storing their ingredients.
     * Hudson, P. (2022), How to let users pick options from a menu. Published: Hacking With Swift. Available at: https://www.hackingwithswift.com/quick-start/swiftui/how-to-let-users-pick-options-from-a-menu
     */
    @State private var selection = "Fridge"
    let placeStored = ["Fridge", "Pantry", "Cupboard", "Cabinet", "Freezer", "Countertop", "Cellar", "Fruit Basket", "Kitchen Cart"]
    
    //code below was reused from https://www.youtube.com/watch?v=YgjYVbg1oiA&ab_channel=CodeWithChris
    @State var isPickerShowing = false
    @State var selectedImage: UIImage?
    
    // code below were reused from https://www.letsbuildthatapp.com/courses/SwiftUI-Firebase-Real-Time-Chat/Save-Images-to-Firebase-Storage
    @State var shouldShowImagePicker = false
    @State var image: UIImage?
    
    
    var userID: String? {
        return Auth.auth().currentUser?.uid }
    
    
    var body: some View {
        @StateObject var itemsViewModel = ItemsViewModel()
        
        NavigationView{
            
            Form {
                /**
                 * The form was reused and adapted from a swiftui form video.
                 * Allen, S. (2021), SwiftUI Form w/ TextField, DatePicker, Toggle, Stepper, Link and Sections w/ Header.
                 * Youtube video available at: https://www.youtube.com/watch?v=m0QQ-hWs8fc&t=31s&ab_channel=SeanAllen
                 */
                /**
                 * The code relating to image and photo below has been reused and adapted from the video below. Aswell as the should show image picker and the image picker.
                 * Voong, B. (2021), SwiftUI Firebase Chat 03: Save Images to Firebase Storage.
                 * Youtube Link Available at: https://www.youtube.com/watch?v=5inXE5d2MUM&t=1056s&ab_channel=LetsBuildThatApp
                 * Source code Available at:  https://www.letsbuildthatapp.com/courses/SwiftUI-Firebase-Real-Time-Chat/Save-Images-to-Firebase-Storage
                 */
                if let image = self.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 128, height: 128)
                }
                else {
                    Image(systemName: "photo")
                        .resizable()
                        .font(.system(size: 64))
                        .padding()
                        .foregroundColor(.gray)
                        .frame(height: 168)
                    Button("Select Image"){
                        shouldShowImagePicker.toggle()
                    }
                    .foregroundColor(.green)
                    
                    // code below was reused from https://www.letsbuildthatapp.com/courses/SwiftUI-Firebase-Real-Time-Chat/Save-Images-to-Firebase-Storage
                    .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
                        ImagePicker(image: $image)
                    }
                }
                
                Section(header: Text("Ingredient name")) {
                    TextField("Item Name", text: $name)
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
                
                Section(header: Text("Category")) {
                    //VStack(alignment: .leading){
                    //https://www.hackingwithswift.com/quick-start/swiftui/how-to-let-users-pick-options-from-a-menu
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
                self.presentationMode.wrappedValue.dismiss()
                itemsViewModel.fetchItemsAfterButton()
            })
        }
    }
    
    /**
     * To develop the save item function, code was reused and adapted from the Firebase documentation.
     * Firebase, (2024), Get realtime updates with Cloud Firestore. Links Available at: https://firebase.google.com/docs/firestore/query-data/listen?,    // https://firebase.google.com/docs/firestore/query-data/queries,  https://firebase.google.com/docs/firestore/query-data/get-data? https://firebase.google.com/docs/firestore/solutions/swift-codable-data-mapping
     */
    func saveItem() {
        guard let userID = userID else {
            print("User not logged in")
            return
        }
        let db = Firestore.firestore()
        
        /**
         * The code relating to image and imageURL has been reused and adapted from the video below. Changes were made to the reference and store image to ensure the images didn't overwrite eachother with unique ID's.
         * Voong, B. (2021), SwiftUI Firebase Chat 03: Save Images to Firebase Storage.
         * Youtube Link Available at: https://www.youtube.com/watch?v=5inXE5d2MUM&t=1056s&ab_channel=LetsBuildThatApp
         * Source code Available at:  https://www.letsbuildthatapp.com/courses/SwiftUI-Firebase-Real-Time-Chat/Save-Images-to-Firebase-Storage
         */
        
        if let image = image {
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
                        "imageURL": imageURLstring
                    ]
                    
                    db.collection("items").document(userID).collection("Item").addDocument(data:itemData) { error in
                        if let error = error {
                            showAlert(message: "Error saving :\(error.localizedDescription)")
                        } else {
                            showAlert(message: "Item saved with photo")
                            name = ""
                            quantity = 1
                            expiryDate = Date()
                            selection = ""
                            description = ""
                            imageURL = ""
                        }
                    }
                }
            }
        }
        else {
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
                }
                
            }
        }
    }
    
    func showAlert(message:String){
        alertMessage = message
        showAlert = true
    }
}



#Preview {
    ScanItem()
}

