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
            Button("Logout"){
                try? Auth.auth().signOut()
                logStatus = false
            }
            List {
                ForEach(itemsViewModel.items, id: \.id) { item in
                    ItemRow(item: item)
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
            }
        
           // .sheet(isPresented: $showPopup)
             //     { NewItemView()
                /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Content@*/Text("Sheet Content")/*@END_MENU_TOKEN@*/
              //    }
            Button("Logout"){
                try? Auth.auth().signOut()
                logStatus = false
                
                
            }
            .padding(.bottom, 10)
            
            Button(action: generateItems){
                Text("Generate")
                    .padding()
                    .foregroundColor(.white)
                    .background(buttonStatus ? Color.green : Color.gray)
                    .cornerRadius(8)
            }
            .padding()
            .disabled(!buttonStatus)
                
            }
        }
    private var buttonStatus: Bool {
           return itemsViewModel.items.contains { $0.isChecked }

       }
    private func generateItems() {
        print("Generate")
   
    }
}

struct ItemRow: View {
    let item: Items
    @State private var isChecked: Bool = false

    var body: some View {
        HStack {
            Image(systemName: isChecked ? "checkmark.square" : "square")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:18, height: 18)
                .onTapGesture {
                    isChecked.toggle()
                   
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


