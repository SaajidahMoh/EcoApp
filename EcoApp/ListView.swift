//
//  ListView.swift
//  EcoApp
//
//  Created by Saajidah Mohamed on 24/03/2024.
//

import SwiftUI
import Firebase

struct ListView: View {
    @AppStorage("log_status") private var logStatus: Bool = false
    @EnvironmentObject var itemsViewModel: ItemsViewModel
    @State private var showPopup = false
    
    var body: some View {
        NavigationView {
                VStack { /**
                          Button("Logout"){
                          try? Auth.auth().signOut()
                          logStatus = false
                          } */
                    List {
                        ForEach(itemsViewModel.items, id: \.id) { item in
                            // ItemRow(item: item)
                            ItemRow(item: item)
                                .environmentObject(itemsViewModel)
                        }
                    }
                    /**
                     List(itemsViewModel.items, id: \.id ) {items in
                     Text(items.name)
                     } */
                    .navigationTitle("Ingredients")
                    .navigationBarItems(trailing: Button(action: {
                        showPopup.toggle()
                        // add
                        //dataManager.addItem(itemName: newItem)
                    }, label: {
                        Image(systemName: "plus")
                    }))
                    .sheet(isPresented:  $showPopup){
                        AddItem()
                        // NewItemView()
                    } //.padding(.bottom, 10)
                    
                    // Spacer()
                    
                    Button(action: generateItems) {
                        Text("Generate")
                            .padding()
                            .foregroundColor(.white)
                            .background(buttonStatus ? Color.green : Color.gray)
                            .cornerRadius(15)
                    }
                    .padding()
                    .disabled(!buttonStatus)
                }
                // .disabled(!buttonStatus)
                
                /** Button("Logout"){
                 try? Auth.auth().signOut()
                 logStatus = false
                 } */
                
                // .sheet(isPresented: $showPopup)
                //     { NewItemView()
                /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Content@*/Text("Sheet Content")/*@END_MENU_TOKEN@*/
                //    }
                /**
                 Button("Logout"){
                 try? Auth.auth().signOut()
                 logStatus = false
                 
                 
                 } */
                // .padding(.bottom, 10)
                
                
                // .padding()
            }
        }
    
        
    private var buttonStatus: Bool {
           //return itemsViewModel.items.contains { $0.isChecked }
        let status = itemsViewModel.items.contains { $0.isChecked }
            print("Button status: \(status)")
            return status
       }
    /**private func generateItems() {
        print("Generate")
   
    } */
    
    private func generateItems() {
        let selectedItems = itemsViewModel.items.filter { $0.isChecked }.map { $0.name }
        Networking.shared.fetchItemsRecipes(with: selectedItems) { recipes, error in
            if let error = error {
                print("Error fetching items' recipes: \(error.localizedDescription)")
                return
            }

            if let recipes = recipes {
                // Handle the fetched recipes here
                print("Fetched recipes: \(recipes)")
            }
        }
    }
}

struct ItemRow: View {
    let item: Items
    @EnvironmentObject var itemsViewModel: ItemsViewModel // Inject itemsViewModel as environment object
    @State private var isChecked: Bool = false

    var body: some View {
        HStack {
            Image(systemName: isChecked ? "checkmark.square" : "square")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:18, height: 18)
                .onTapGesture {
                    isChecked.toggle()
                    itemsViewModel.updateItem(itemID: item.id, isChecked: isChecked) // Access itemsViewModel here
                    print("\(item.name) checked : \(isChecked)")
                }
                .padding(.trailing, 8)

            Text(item.name)
                .padding(.leading, 8)

            Spacer()
        }
    }

}





#Preview {
    ListView()
        //.environmentObject(itemsViewModel)
}


