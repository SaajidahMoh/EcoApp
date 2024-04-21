//
//  ListView.swift
//  EcoApp
//
//  Created by Saajidah Mohamed on 24/03/2024.
//

import SwiftUI
import Firebase
import UserNotifications

struct ListView: View {
    @AppStorage("log_status") private var logStatus: Bool = false
    @EnvironmentObject var itemsViewModel: ItemsViewModel
    @State private var showPopup = false
    /**@State private var activeTab: Tab = .active
     
     enum Tab: String, CaseIterable {
     case active = "Active"
     case expired = "Expired"
     }
     
     var ingredientsSection:[Items]{
     switch activeTab{
     case .active:
     return itemsViewModel.items.filter { $0.expiryDate.dateValue() > Date() || $0.expiryDate.dateValue() == Date()
     }
     case .expired:
     return itemsViewModel.items.filter { $0.expiryDate.dateValue() < Date()
     }
     
     }
     
     } */
    
    var userID: String? {
        return Auth.auth().currentUser?.uid }
    
    var body: some View {
        NavigationView {
            VStack { /**
                      Button("Logout"){
                      try? Auth.auth().signOut()
                      logStatus = false
                      } */
                
                /**Picker("", selection: $activeTab) {
                 ForEach(Tab.allCases, id:  \.self) { option in
                 Text(option.rawValue)
                 }
                 }
                 .pickerStyle(.segmented)
                 .listRowInsets(.init(top: 15, leading: 0, bottom: 0, trailing: 15))
                 .listRowSeparator(.hidden)
                 */
                
                
                List {
                    ForEach(itemsViewModel.items, id: \.id) { item in
                        //ForEach(ingredientsSection, id: \.id) { item in
                        // ItemRow(item: item)
                        ItemRow(item: item)
                            .environmentObject(itemsViewModel)
                        //notifications
                            .onAppear {
                                scheduleNotification(for: item)
                            }
                        // https://peterfriese.dev/blog/2021/swiftui-listview-part4/#:~:text=of%20styling%20options)-,Swipe%2Dto%2Ddelete,loop%20inside%20a%20List%20view.
                        /** .onDelete { indexSet in
                         //item.remove(atOffsets: indexSet)
                         itemsViewModel.deleteItem(atOffsets: indexSet)
                         } */
                    }
                    // https://www.youtube.com/watch?v=FPLQXCmvA7o&ab_channel=PaulHudson
                    .onDelete(perform: deleteItems)
                    
                    // https://www.youtube.com/watch?v=KMtdBgHwvGY&ab_channel=JohnGallaugher
                    //.onDelete { indexSet in ItemsViewModel.remove(attOffsets: indexSet)}
                    
                    
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
                // https://www.letsbuildthatapp.com/courses/SwiftUI-Firebase-Real-Time-Chat/Save-Images-to-Firebase-Storage
                .fullScreenCover(isPresented: $showPopup, onDismiss: nil) {
                    AddItem()
                }
                /**
                 .sheet(isPresented:  $showPopup){
                 AddItem()
                 // NewItemView()
                 } //.padding(.bottom, 10)
                 */
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
            .background(Color(UIColor.systemGroupedBackground)) // fixes generate button background!
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
    
    //https://vikramios.medium.com/mastering-swift-local-notifications-a-developers-guide-f56b77ab64cc
    private func scheduleNotification(for item: Items) {
        let daysDifference = Calendar.current.dateComponents([.day], from: Date(), to: item.expiryDate.dateValue()).day ?? 0
        
        //if daysDifference 0= 0 || daysDifference <= 3
        if daysDifference >= 0 && daysDifference <= 3 {
            let content = UNMutableNotificationContent()
            content.title = "Your Ingredient is Expiring"
            content.body = "\(item.name) is expiring \(daysDifference == 0 ? "today" : "very soon, use or donate")!"
            content.sound = UNNotificationSound.default
            
            //https://stackoverflow.com/questions/58561877/error-in-trigger-for-notifications-swift
            //var hours = [9, 12, 18]
            var triggerDate = DateComponents()
            triggerDate.hour = 20
            triggerDate.minute = 19
            
            var triggerDateAfternoon = DateComponents()
            triggerDateAfternoon.hour = 10
            triggerDateAfternoon.minute = 30
            
            var triggerDateEvening = DateComponents()
            triggerDateEvening.hour = 10
            triggerDateEvening.minute = 32
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
            let trigger2 = UNCalendarNotificationTrigger(dateMatching: triggerDateAfternoon, repeats: true)
            let trigger3 = UNCalendarNotificationTrigger(dateMatching: triggerDateEvening, repeats: true)
            
            
            let request = UNNotificationRequest(identifier: item.id, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling notification for \(item.name): \(error.localizedDescription)")
                } else {
                    print("Notification scheduled successfully for \(item.name)")
                }
            }
            
            let request2 = UNNotificationRequest(identifier: item.id, content: content, trigger: trigger2)
            UNUserNotificationCenter.current().add(request2) { error in
                if let error = error {
                    print("Error scheduling notification for \(item.name): \(error.localizedDescription)")
                } else {
                    print("Notification scheduled successfully for \(item.name)")
                }
            }
            
            let request3 = UNNotificationRequest(identifier: item.id, content: content, trigger: trigger3)
            UNUserNotificationCenter.current().add(request3) { error in
                if let error = error {
                    print("Error scheduling notification for \(item.name): \(error.localizedDescription)")
                } else {
                    print("Notification scheduled successfully for \(item.name)")
                }
            }
            
        }
    }
    
    
    private var buttonStatus: Bool {
        //return itemsViewModel.items.contains { $0.isChecked }
        let status = itemsViewModel.items.contains { $0.isChecked }
        print("Button status: \(status)")
        return status
    }
    
    
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
    /**
     private func deleteItems(at offsets:IndexSet){
     itemsViewModel.items.remove(atOffsets: offsets)
     
     } */
    
    /**
     private func deleteItems(at offsets: IndexSet) {
     for index in offsets {
     let item = itemsViewModel.items[index]
     if let userID = userID {
     let db = Firestore.firestore()
     db.collection("items").document(userID).collection("Item").document(item.id).delete { error in
     if let error = error {
     print("Error deleting item \(item.name): \(error.localizedDescription)")
     } else {
     print("Item \(item.name) deleted successfully.")
     }
     }
     }
     }
     // Remove items from the ViewModel after deleting from the database
     itemsViewModel.items.remove(atOffsets: offsets)
     } */
    /**
     private func deleteItems(at offsets: IndexSet) {
     for index in offsets {
     let item = itemsViewModel.items[index]
     if let userID = userID {
     let db = Firestore.firestore()
     let collectionRef = db.collection("items").document(userID).collection("Item")
     //let documentRef = db.collection("items").document(userID).collection("Item").document(item.id)
     
     
     collectionRef.whereField("id", isEqualTo: item.id).getDocuments {
     (QuerySnapshot, error) in
     if let error = error {
     print("Error getting item's document for \(item.name): \(error.localizedDescription)")
     return
     }
     
     /**guard let documents = QuerySnapshot?.documents, let document = documents.first else {
      print ("Document not found for item  \(item.name)")
      return
      } */
     
     guard let documents = QuerySnapshot?.documents else {
     print ("Document not found for item  \(item.name)")
     return
     }
     
     /**guard let document = documents.first else {
      print ("Document not found for item  \(item.name)")
      return
      } */
     
     if let document = documents.first {
     let documentID = document.documentID
     collectionRef.document(documentID).delete { error in
     if let error = error {
     print("Error deleting item \(item.name): \(error.localizedDescription)")
     } else {
     print("Item \(item.name) deleted successfully.")
     itemsViewModel.items.remove(at: index)
     }
     }
     /** documentRef.delete { error in
      if let error = error {
      print("Error deleting item \(item.name): \(error.localizedDescription) for \(userID) for item \(item.id)")
      } else {
      print("Item \(item.name) deleted successfully for \(userID) for item \(item.id).")
      // Remove item from ViewModel after successful deletion
      itemsViewModel.items.remove(at: index)
      }
      }
      } */
     } else {
     print("No document found for item \(item.name) with id \(item.id)")
     }
     }
     }
     }
     } */
    
    // https://www.youtube.com/watch?v=FPLQXCmvA7o&ab_channel=PaulHudson
    // https://docs.airnativeextensions.com/docs/firebase/firestore/transactions-and-batched-writes/
    
    // https://www.youtube.com/watch?v=KcOvWU3xp1I&t=273s&ab_channel=JohnGallaugher
    private func deleteItems(at offsets: IndexSet) {
        // var itemsToDelete: [Items] = []
        
        for index in offsets {
            let item = itemsViewModel.items[index]
            
            if let userID = userID {
                let db = Firestore.firestore()
                // https://firebase.google.com/docs/firestore/query-data/queries
                // https://firebase.google.com/docs/firestore/solutions/swift-codable-data-mapping
                //https://peterfriese.dev/blog/2020/swiftui-firebase-fetch-data/
                let collectionRef = db.collection("items").document(userID).collection("Item")
                
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
                        collectionRef.document(documentID).delete { error in
                            if let error = error {
                                print("Error deleting item \(item.name): \(error.localizedDescription)")
                            } else {
                                print("Item \(item.name) with id \(item.id) deleted successfully.")
                                
                                // chat GPT: https://chat.openai.com/share/b7135e73-7ca1-4b11-aae4-717e57f26e82
                                DispatchQueue.main.async {
                                    if let index = itemsViewModel.items.firstIndex(where: { $0.id == item.id}) {
                                        itemsViewModel.items.remove(at: index)
                                    }
                                    
                                }
                            }
                        }
                    } else {
                        print("No document found for item \(item.name)")
                    }
                }
            }
        }
    }
}
    
    
    


struct ItemRow: View {
    let item: Items
    @EnvironmentObject var itemsViewModel: ItemsViewModel
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
        
        //setting the day so it accurately displays the date todat
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let expiryDate = calendar.startOfDay(for: item.expiryDate.dateValue())
        let daysDifference = Calendar.current.dateComponents([.day], from: today, to: expiryDate).day ?? 0
        //let daysDifference = Calendar.current.dateComponents([.day], from: Date(), to: item.expiryDate.dateValue()).day ?? 0
        
        if daysDifference == -1 {
            return "Expired yesterday"
        } else if daysDifference == 0 {
            return "Expiring today"
        } else if daysDifference == 1 {
            return "Expiring tomorrow"
        } else if daysDifference < 0 {
            return "Expired on: \(expiryDateFormatter)"
        }  else {
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
            return .yellow
        } else {
            return .primary // Default color
        }
    }
    
    var body: some View {
        
       // let daysDifference = Calendar.current.dateComponents([.day], from: Date(), to: item.expiryDate.dateValue()).day ?? 0
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
            
            Image(systemName: "ellipsis")
                    //"pencil")
            //"rectangle.and.pencil.and.ellipsis")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:12, height: 12)
               // .padding(.trailing)
        
    //}
                .padding(.leading, 8)
            //own code
                .onTapGesture {
                    isShown.toggle()
                }
            /**
                .sheet(isPresented: $isShown){
                    EachItemView(item: item)
                }
             */
            
            // https://www.letsbuildthatapp.com/courses/SwiftUI-Firebase-Real-Time-Chat/Save-Images-to-Firebase-Storage
            .fullScreenCover(isPresented: $isShown, onDismiss: nil) {
                EachItemView(item: item)
                   }
             
           // Spacer()
        }
        
    }
       
}

struct EachItemView: View {
    let item: Items
    @State private var editShown = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // https://medium.com/swlh/swift-working-with-dates-1-basic-types-date-dateformatter-datecomponent-4bfc376ee93b
    // https://developer.apple.com/documentation/foundation/dateformatter
    // https://www.swiftyplace.com/blog/swift-date-formatting-10-steps-guide
    private var expiryDateFormatter: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        return dateFormatter.string(from: item.expiryDate.dateValue())
    }
    
    var body: some View{
        //VStack{
        //HStack {
        NavigationView {
            
            // ZStack(alignment: .topLeading){
            Form {
                
                /** Section(header: Text("Ingredient name")) {
                 Text("Name: \(item.name)")
                 }
                 */
                
                
                Section(header: Text("Ingredient name")) {
                    Text(" \(item.name)")
                }
                
                Section(header: Text("Quantity")) {
                    Text("\(item.quantity)")
                }
                
                Section(header: Text("Expiry date")) {
                    Text("\(expiryDateFormatter)")
                }
                
                /**
                 Section(header: Text("Description")) {
                 Text("\(item.description)")
                 }*/
                
                if !item.description.isEmpty {
                    Section(header: Text("Description")) {
                        Text("\(item.description)")
                    }
                }
            }
            
    
            .navigationTitle("Ingredient Details")
            /**
            .navigationBarItems(trailing: Button(action: {
                editShown.toggle()
                // add
                //dataManager.addItem(itemName: newItem)
            }, label: {
                Image(systemName: "pencil.circle")
            }))
            // https://www.letsbuildthatapp.com/courses/SwiftUI-Firebase-Real-Time-Chat/Save-Images-to-Firebase-Storage
            .fullScreenCover(isPresented: $editShown, onDismiss: nil) {
                EditItem()
            }
            */
            
            /**
            .navigationBarItems(leading:
                                    Button("Cancel") {
                self.presentationMode.wrappedValue.dismiss()
                //isPresented = false
                //showEmailVerificationView = false
            }
                .foregroundColor(.green), trailing:
                                    Button("Edit") {
                EditItem()
                
            } .foregroundColor(.green)
                .bold()
            
                    
            
            ) */
            
            /**
           .navigationBarItems(leading:
                                    Button(action : {
                self.presentationMode.wrappedValue.dismiss()
                //isPresented = false
                //showEmailVerificationView = false
            }) { Image(systemName: "arrow.left")}
                .padding()
                                
                .foregroundColor(.green), trailing:
                                    Button("Edit") {
                EditItem()
            } .foregroundColor(.green)
                .bold()
            
                    
            
            ) */
            
            
        
            
                
                
                //  .navigationTitle("Ingredients")
               /**  .navigationBarItems(trailing: Button(action: {
                     editShown.toggle()
                 }) { Image(systemName: "ellipses")}
                                     ) */
                 
                 
            .navigationBarItems(leading: Button(action : {
               // editShown = false
                self.presentationMode.wrappedValue.dismiss()
            }, label : {
                Image(systemName: "arrow.left")
                    .foregroundColor(.green)
            }),
                    
                    trailing: Button(action: {
                    editShown.toggle()
                    // add
                    //dataManager.addItem(itemName: newItem)
                }, label: {
                    Image(systemName: "rectangle.and.pencil.and.ellipsis")
                        .foregroundColor(.green)
                }))
           // .foregroundColor(.green)
             //   .bold()
                // https://www.letsbuildthatapp.com/courses/SwiftUI-Firebase-Real-Time-Chat/Save-Images-to-Firebase-Storage
                .sheet(isPresented: $editShown, onDismiss: nil) {
                    EditItem(item: item)
                   // EditItem(item: item)
                }
                
            }
        

        
        //.navigationTitle("\(item.name)")
    }
}



#Preview {
    ListView()
        //.environmentObject(itemsViewModel)
}


