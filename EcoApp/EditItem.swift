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
    @State private var imageURL = ""
    
    //https://www.hackingwithswift.com/quick-start/swiftui/how-to-let-users-pick-options-from-a-menu
        @State private var selection = ""
        let place = ["Fridge", "Pantry", "Cupboard", "Cabinet", "Freezer"]
    
    //https://www.youtube.com/watch?v=YgjYVbg1oiA&ab_channel=CodeWithChris
   // @State var isPickerShowing = false
   // @State var selectedImage: UIImage?
    
    @State var shouldShowImagePicker = false // https://www.letsbuildthatapp.com/courses/SwiftUI-Firebase-Real-Time-Chat/Save-Images-to-Firebase-Storage
    
    @State var image: UIImage?
    
    let item: Items
    
    var userID: String? {
        return Auth.auth().currentUser?.uid }
    
    
    var body: some View {
        @StateObject var itemsViewModel = ItemsViewModel()
        
        // Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        NavigationView{
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
                        
                    } else {Image(systemName: "photo")
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
                
                // https://www.hackingwithswift.com/forums/swiftui/help-with-onchange/24312 TimeStamp 00:00:00
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
                
                Section(header: Text("Category")) {
                    //VStack(alignment: .leading){
                   //https://www.hackingwithswift.com/quick-start/swiftui/how-to-let-users-pick-options-from-a-menu
                    Picker("Select A Cateogry", selection: $selection){
                        ForEach(place, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
                    .onAppear {
                        selection = item.selection
                    }
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
                //isPresented = false
                //showEmailVerificationView = false
            }
                .foregroundColor(.green), trailing:
                                    Button("Update") {
                updateNewItem()
                
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
             //   self.persistImageToStorage() //copied LBTA
               
                    // goBack = true
            })

        }
        
    }
    
    /**private func persistImageToStorage(){
        guard let userID = userID else {
            print("User not logged in")
            return
        }
        // https://www.letsbuildthatapp.com/courses/SwiftUI-Firebase-Real-Time-Chat/Save-Images-to-Firebase-Storage
        // https://www.letsbuildthatapp.com/courses/SwiftUI-Firebase-Real-Time-Chat/Save-Images-to-Firebase-Storage
        let ref = Storage.storage().reference(withPath: userID)
        
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
                        
                       // print(url?.absoluteString)
                        
                        // https://www.letsbuildthatapp.com/courses/SwiftUI-Firebase-Real-Time-Chat/Installing-Firestore-and-Saving-User-Data-Collection
                      //  self.storeItemImage(imageItemUrl: url)
                    }
                }
            
        
    }*/
    /**private func storeItemImage(imageItemUrl: URL) {
        guard let userID = userID else {
            print("User not logged in")
            return
        }
    
        Storage.storage.firestore.collection("items").document(userID).collection("Item").addDoc
        
        
        
    } */
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
        
        // https://firebase.google.com/docs/firestore/query-data/queries
        // https://firebase.google.com/docs/firestore/solutions/swift-codable-data-mapping
    //https://peterfriese.dev/blog/2020/swiftui-firebase-fetch-data/
        
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
                
                let updateData: [String:Any] = [
                    "id" : UUID().uuidString,
                    "name": name,
                    "quantity": quantity,
                    "expiryDate": expiryDate,
                    "description": description,
                    "selection": selection,
                    "imageURL": imageURL
                ]
                
                
                // https://firebase.google.com/docs/firestore/manage-data/add-data
                collectionRef.document(documentID).setData(updateData, merge: true){ error in
                    if let error = error {
                        print("Error updating item \(item.name): \(error.localizedDescription)")
                    } else {
                        print("Item \(item.name) with id \(item.id) updated successfully.")
                        
                        // Add the index to the delete from list
                    }
                }
            } else {
                print("No document found for item \(item.name)")
            }
        }


        
    }
    
    
        func showAlert(message:String){
            alertMessage = message
            showAlert = true
        
    }
}
    
                     
/**
#Preview {
    EditItem(item: item)
}
*/
