//
//  NewItemView.swift
//  EcoApp
//
//  Created by Saajidah Mohamed on 24/03/2024.
// https://www.youtube.com/watch?v=6b2WAePdiqA&ab_channel=LoganKoshenka: Complete SwiftUI Firebase Tutorial: Auth, Sign Up Page, Cloud Firestore, Read & Write Data
// https://www.youtube.com/watch?v=m0QQ-hWs8fc&t=31s&ab_channel=SeanAllen

import SwiftUI
import Firebase

struct NewItemView: View {
    @State private var name = ""
    @State private var quantity = 1
    @State private var expirydate = Date()
    @State private var description = ""
    
    @AppStorage("log_status") private var logStatus: Bool = false
    @State private var selectedImage: UIImage? = nil
    @State var shouldShowImagePicker = false
    @State var goBack = false
    
    var body: some View {
        NavigationView{
            
            Form {
                Section(header: Text("Image")){
                    if let image =  selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 208, height: 128)
                           // .cornerRadius(64)
                        //.aspectRatio(contentMode: .fit)
                           // .frame(height: 100)
                    } else {
                        Image(systemName: "photo")
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
                                     }
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
                        .frame(height: 40)
                        .multilineTextAlignment(.leading)
                    
                }
                
            }
            .accentColor(.red)
            .navigationTitle("Ingredient")
           .navigationBarItems(leading:
                                Button(action: {
               goBack.toggle()
           }) {Image(systemName: "arrow.left")
           }
            .foregroundColor(.green)
                               )
                                    
                                //    NavigationLink(destination: ItemsViewModel()) {
           // .navigationBarItems(leading:
            //                        Button(action: {
          //  role: .cancel
           /** }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(.green)
            }) */
    
            
        
            .toolbar {
                Button("  Save  "){
                    saveItem()
                }
                .foregroundColor(.green)
                .bold()
                
               //  .border(Color.green, width:2)
            }
        }
    }

    func saveItem(){
        
    }
}

#Preview {
    NewItemView()
}
