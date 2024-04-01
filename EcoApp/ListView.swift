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
                    
                     Spacer()
                    
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
    @State private var isShown = false
    
    // https://medium.com/swlh/swift-working-with-dates-1-basic-types-date-dateformatter-datecomponent-4bfc376ee93b
   /** private var expiryDateFormatter: String {
        let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "EEEE, dd MMM yyyy"
        
        // let dateStr = dateFormatter.string(from: date)
        //  print(dateStr)
        dateFormatter.dateStyle = .medium
        let expiryDate = Date(timeIntervalSinceReferenceDate: item.expiryDate)
        return dateFormatter.string(from: expiryDate)
        
    } */
    private var expiryDateFormatter: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        return dateFormatter.string(from: item.expiryDate.dateValue())
    }
    
    private var expiryDateStatus: String {
        let daysDifference = Calendar.current.dateComponents([.day], from: Date(), to: item.expiryDate.dateValue()).day ?? 0
        
        if daysDifference < 0 {
            return "Expired on: \(expiryDateFormatter)"
        } else if daysDifference == 0 {
            return "Expiring today"
        } else {
            return "Expires: \(expiryDateFormatter)"
        }
    }
    
    // expiry date Red
    //https://developer.apple.com/documentation/foundation/calendar/2293176-datecomponents
    private func expiryDateRed() -> Color {
        // Calculate the difference in days between today and the expiry date
        // no date returns 0
        let daysDifference = Calendar.current.dateComponents([.day], from: Date(), to: item.expiryDate.dateValue()).day ?? 0
        
        // If the expiry date is within 3 days from today, return red, otherwise return the default color
        /**if daysDifference <= 3 && daysDifference >= 0 {
         return .red
         } else {
         return .primary // Default color
         } */
        if daysDifference <= 0 {
            return .red
        } else if daysDifference <= 3 {
            return .brown
        } else {
            return .primary // Default color
        }
    }
    
    var body: some View {
        
        let daysDifference = Calendar.current.dateComponents([.day], from: Date(), to: item.expiryDate.dateValue()).day ?? 0
        
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
            
            // VStack(alignment: .leading){
            Text(item.name)
                .font(.headline)
            
            Text("Qty: \(item.quantity)")
                .font(.subheadline)
      
            Spacer()
            
            Text(expiryDateStatus)
        // Text("\(expiryDateFormatter)")
            .font(.subheadline)
            .foregroundColor(expiryDateRed())
        // .multilineTextAlignment(.trailing)
        //.bold()
        
    //}
                .padding(.leading, 8)
            //own code
                .onTapGesture {
                    isShown.toggle()
                }
                .sheet(isPresented: $isShown){
                    EachItemView(item: item)
                }
            
           // Spacer()
        }
    }
}

struct EachItemView: View {
    
    // https://medium.com/swlh/swift-working-with-dates-1-basic-types-date-dateformatter-datecomponent-4bfc376ee93b
    // https://developer.apple.com/documentation/foundation/dateformatter
    private var expiryDateFormatter: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        return dateFormatter.string(from: item.expiryDate.dateValue())
    }

    let item: Items
    
    var body: some View{
        VStack{
            Text("Name: \(item.name)")
            Text("Quantity: \(item.quantity)")
            Text("Expiry Date: \(expiryDateFormatter)")
            Text("Description: \(item.description)")
        }
        .navigationTitle("\(item.name)")
    }
}




#Preview {
    ListView()
        //.environmentObject(itemsViewModel)
}


