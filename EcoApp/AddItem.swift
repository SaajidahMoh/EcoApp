//
//  AddItem.swift
//  EcoApp
//
//  Created by Saajidah Mohamed on 29/03/2024.
// https://www.youtube.com/watch?v=6b2WAePdiqA&ab_channel=LoganKoshenka: Complete SwiftUI Firebase Tutorial: Auth, Sign Up Page, Cloud Firestore, Read & Write Data
// https://www.youtube.com/watch?v=m0QQ-hWs8fc&t=31s&ab_channel=SeanAllen

import SwiftUI
import Firebase
import FirebaseStorage


struct AddItem: View {
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
    
//https://www.hackingwithswift.com/quick-start/swiftui/how-to-let-users-pick-options-from-a-menu
    @State private var selection = "Fridge"
    let place = ["Fridge", "Pantry", "Cupboard", "Cabinet", "Freezer", "Countertop", "Cellar", "Fruit Basket", "Kitchen Cart"]
    
//https://www.youtube.com/watch?v=YgjYVbg1oiA&t=1327s&ab_channel=CodeWithChris
    @State var isPickerShowing = false
    @State var selectedImage: UIImage?
    
    //https://www.youtube.com/watch?v=YgjYVbg1oiA&ab_channel=CodeWithChris
   // @State var isPickerShowing = false
   // @State var selectedImage: UIImage?
    
    @State var shouldShowImagePicker = false // https://www.letsbuildthatapp.com/courses/SwiftUI-Firebase-Real-Time-Chat/Save-Images-to-Firebase-Storage
    
    @State var image: UIImage?
    
    
    var userID: String? {
        return Auth.auth().currentUser?.uid }
    
    
    var body: some View {
        @StateObject var itemsViewModel = ItemsViewModel()
        
        // Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        NavigationView{
            /** Section(header: Text("Image")){
             if let image =  selectedImage {
                 Image(uiImage: image)
                     .resizable()
                     .scaledToFill()
                     .frame(width: 208, height: 128)
                    // .cornerRadius(64)
                 //.aspectRatio(contentMode: .fit)
                    // .frame(height: 100)
             } else {
                 Image(systemName: "persin.fill")
                     .resizable()
                     .aspectRatio(contentMode: .fit)
                     .frame(height: 100)
                     .padding()
                     .foregroundColor(.gray)
             }
             Button("Select Image"){
                 shouldShowImagePicker.toggle()
             }
             .multilineTextAlignment(.trailing)
             .sheet(isPresented: $shouldShowImagePicker){
                 ImagePicker(image: $selectedImage)
             }
                              }*/
            Form {
                
                //  Section(header: Text("Image")){
                // https://www.letsbuildthatapp.com/courses/SwiftUI-Firebase-Real-Time-Chat/Save-Images-to-Firebase-Storage
                 if let image = self.image {
                 //if selectedImage != nil {
                 //if let selectedImage = self.selectedImage {
                 // https://www.youtube.com/watch?v=YgjYVbg1oiA&ab_channel=CodeWithChris
                 // Image(uiImage: selectedImage!)
                 Image(uiImage: image)
                 .resizable()
                 .scaledToFill()
                 .frame(width: 128, height: 128)
                 // .cornerRadius(64)
                     Button("Select Image"){
                         shouldShowImagePicker.toggle()
                     }
                     .foregroundColor(.green)
                     
                 }
                /**
                if selectedImage != nil {
                    Image(uiImage: selectedImage!)
                        .resizable()
                        .frame(width: 200, height:200)
                } 
                Button
                {
                    isPickerShowing = true
                } label : {
                    Text("Select a photo")
                }
                 .sheet(isPresented: $isPickerShowing,  onDismiss: nil) {
                    ImagePicker(image:  $selectedImage)
                }
                if selectedImage == nil {
                    Image(systemName: "photo")
                                  .resizable()
                                  .font(.system(size: 64))
                                  .padding()
                              // .foregroundColor(Color(.label))
                                  .foregroundColor(.gray)
                                  .frame(height: 150)
                    Button("Select Image"){
                        isPickerShowing.toggle()
                    }
                } */
                
                else {Image(systemName: "photo")
                            .resizable()
                            .font(.system(size: 64))
                            .padding()
                        // .foregroundColor(Color(.label))
                            .foregroundColor(.gray)
                            .frame(height: 150)
                        Button("Select Image"){
                            shouldShowImagePicker.toggle()
                        }
                        .foregroundColor(.green)
                      //  .sheet(isPresented: $isPickerShowing, onDismiss: nil) {
                      //      ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing)}
                    
                            // ImagePicker(image: $self.image))
                        // https://www.letsbuildthatapp.com/courses/SwiftUI-Firebase-Real-Time-Chat/Save-Images-to-Firebase-Storage
                        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
                                   ImagePicker(image: $image)
                               }
                            
                            //Image(image)
                        
                    } 
                
               // }
                Section(header: Text("Ingredient name")) {
                    TextField("Item Name", text: $name)
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
            .accentColor(.red)
            .navigationTitle("Ingredient")
            .navigationBarItems(leading:
                                    Button("Cancel") {
                self.presentationMode.wrappedValue.dismiss()
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
              //  self.persistImageToStorage() //copied LBTA
               
                    // goBack = true
            })

        }
        
    }
    /**
    private func persistImageToStorage(){
        guard let userID = userID else {
            print("User not logged in")
            return
        }
        // https://www.letsbuildthatapp.com/courses/SwiftUI-Firebase-Real-Time-Chat/Save-Images-to-Firebase-Storage
        // https://www.letsbuildthatapp.com/courses/SwiftUI-Firebase-Real-Time-Chat/Save-Images-to-Firebase-Storage
        let storeImage = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "images/\(userID)/\(storeImage)")
        
        
        //"images/\(userID)/\(UUID().uuidString).jpg")
        
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
                        showAlert(message: "Successfully stored image with url: \(url?.absoluteString ?? "")")
                        
                        print(url?.absoluteString)
                        
                        // https://www.letsbuildthatapp.com/courses/SwiftUI-Firebase-Real-Time-Chat/Installing-Firestore-and-Saving-User-Data-Collection
                      //  self.storeItemImage(imageItemUrl: url)
                    }
                }
            
        
    }
     */
    /**
    // https://www.youtube.com/watch?v=YgjYVbg1oiA&t=1327s&ab_channel=CodeWithChris
    func uploadPhoto(){
        guard selectedImage != nil else {
            return
        }
        
        let storageRef = Storage.storage().reference()
        
        
    } */
    /**private func storeItemImage(imageItemUrl: URL) {
        guard let userID = userID else {
            print("User not logged in")
            return
        }
    
        Storage.storage.firestore.collection("items").document(userID).collection("Item").addDoc
        
        
        
    } */
    func saveItem() {
        guard let userID = userID else {
            print("User not logged in")
            return
        }
        let db = Firestore.firestore()
        
        //https://www.letsbuildthatapp.com/courses/SwiftUI-Firebase-Real-Time-Chat/Save-Images-to-Firebase-Storage
        
        if image != nil {
        //if let image = image {
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
                    // showAlert(message: "Successfully stored image with url: \(url?.absoluteString ?? "")")
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
                    
                    
                    // db.collection("items").document(userID).collection("Item")
                    //  let ref = db.collection("items").document(userID).collection("Item")
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
                            // image = nil
                            //ListView()
                            //isPresented = false
                        }
                    }
                    
                }
                
            }
        }
        else {
            
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
            
            
            // db.collection("items").document(userID).collection("Item")
            //  let ref = db.collection("items").document(userID).collection("Item")
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
    }
    
        func showAlert(message:String){
            alertMessage = message
            showAlert = true
        
    }
}
    
                     

#Preview {
    AddItem()
}
