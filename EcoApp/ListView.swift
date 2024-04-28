//
//  ListView.swift
//  EcoApp
//
//  Created by Saajidah Mohamed on 24/03/2024.
//

import SwiftUI
import Firebase
import UserNotifications
import Kingfisher

struct ListView: View {
    @AppStorage("log_status") private var logStatus: Bool = false
    @EnvironmentObject var itemsViewModel: ItemsViewModel
    @State private var showPopup = false
    @State private var showAddItem = false
    
    @State private var barcode_string: String?
    @State private var foundProduct: Product?
    @State private var showScanItem = false
    @State private var showDeleteIng = false
    @State private var sortedTab: Tab = .expiryDate
   // @State private var sortedTab1: Tab = .defaultSetting
    
    //@State private var activeTab: seperateTab = .active
    @State private var activeTab: seperateTab = .active
    //private var ingredientsQuery: String = ""
    
    @State private var navigateToNextPage = false
    @State private var recipesBasedOnIngredients : [RecipesBasedIngredients] = []
    @State private var recipesSteps: [RecipeStep] = []
    
    
    
    enum seperateTab: String, CaseIterable {
    case active = "Active"
    case expired = "Expired"
    }
    
    enum Tab: String, CaseIterable{
        case expiryDate
        case category
    }
    
    var sortedItems:[Items]{
        switch sortedTab {
        case .expiryDate:
            // convert timestamp to date.
            return itemsViewModel.items.sorted(by: {$0.expiryDate.dateValue() < $1.expiryDate.dateValue() })
        case .category:
                //return itemsViewModel.items
            return itemsViewModel.items.sorted(by:{$0.expiryDate.dateValue() < $1.expiryDate.dateValue() })
                                                //{$0.selection < $1.selection })
        }
    }
    
   /** var ingredientsSection:[Items]{
    switch activeTab{
    case .active:
    return itemsViewModel.items.filter { $0.expiryDate.dateValue() > Date() || $0.expiryDate.dateValue() == Date()
    }
    case .expired:
    return itemsViewModel.items.filter { $0.expiryDate.dateValue() < Date()
    }
    
    }
    
    } */
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
                
                /** Picker("", selection: $activeTab) {
                 ForEach(seperateTab.allCases, id:  \.self) { option in
                 Text(option.rawValue)
                 }
                 }
                 .pickerStyle(.segmented)
                 .listRowInsets(.init(top: 15, leading: 0, bottom: 0, trailing: 15))
                 .listRowSeparator(.hidden)
                 */
                
                /**if activeTab == .active {
                 Picker("", selection: $activeTab) {
                 ForEach(seperateTab.allCases, id:  \.self) { option in
                 Text(option.rawValue)
                 }
                 }
                 .pickerStyle(.segmented)
                 .listRowInsets(.init(top: 15, leading: 0, bottom: 0, trailing: 15))
                 .listRowSeparator(.hidden)
                 }
                 if activeTab == .expired {
                 Picker("", selection: $activeTab) {
                 ForEach(seperateTab.allCases, id:  \.self) { option in
                 Text(option.rawValue)
                 }
                 }
                 .pickerStyle(.segmented)
                 .listRowInsets(.init(top: 15, leading: 0, bottom: 0, trailing: 15))
                 .listRowSeparator(.hidden)
                 }
                 */
                
                /**   List {
                 
                 
                 ForEach(sortedItems, id: \.id) { item in
                 // ForEach(itemsViewModel.items, id: \.id) { item in
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
                 
                 
                 }*/
                
                List {
                    if sortedTab == .category {
                        // New list of categories
                        let categList = Set(sortedItems.map { $0.selection })
                        
                        // sort items for each list
                        ForEach(categList.sorted(), id: \.self) { category in
                            let eachItem = sortedItems.filter { $0.selection == category }
                            
                            // display output
                            Section(header: Text(category)) {
                                ForEach(eachItem, id: \.id) { item in
                                    ItemRow(item: item)
                                        .environmentObject(itemsViewModel)
                                        .onAppear {
                                            scheduleNotification(for: item)
                                        }
                                }
                                // .onDelete(perform: deleteItems) // Move onDelete to the ForEach within the Section
                            }
                        }
                    } else {
                        // If not sorted by category, display items without sections
                        ForEach(sortedItems, id: \.id) { item in
                            ItemRow(item: item)
                                .environmentObject(itemsViewModel)
                                .onAppear {
                                    scheduleNotification(for: item)
                                } .swipeActions {
                                    Button("Delete"){
                                        deleteItem(for: item)
                                    }
                                   // .background(Color.red)
                                    .tint(.red)
                                }
            
                        }
                        //.//onDelete(perform: deleteItems) // Apply onDelete to the ForEach
                    }
                }
                
                
                
                /**
                 List(itemsViewModel.items, id: \.id ) {items in
                 Text(items.name)
                 } */
                .navigationTitle("Ingredients")
                // https://swiftwithmajid.com/2020/08/05/menus-in-swiftui/
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Menu {
                            Section {
                                Button(action: {
                                    showAddItem.toggle()
                                }) {
                                    Label("Add Item", systemImage: "text.badge.plus")
                                }
                                
                                Button(action: {
                                    //showScanItem.toggle()
                                    showScanItem = true
                                }) {
                                    Label("Scan Item", systemImage: "barcode.viewfinder")
                                }
                            }
                            
                            Section(header: Text("Sorting")) {
                                Button(action: {
                                    sortedTab = .expiryDate
                                }) {
                                    Label("Sort By Date", systemImage: sortedTab == .expiryDate ? "checkmark" : "arrow.up.arrow.down")
                                    // .foregroundColor(.red)
                                }
                                Button(action: {sortedTab = .category}) {
                                    Label("Sort By Category", systemImage: sortedTab == .category ? "checkmark" : "list.star")
                                    //     .foregroundColor(.red)
                                }
                                
                                /** Button(action: {activeTab = .active}) {
                                 Label("Active vs Expired", systemImage: activeTab == .active ? "checkmark" : "list.star")
                                 //     .foregroundColor(.red)
                                 } */
                                
                                
                                
                                /**  Button(action:  {sortedTab = .defaultSetting}) {
                                 Label("Default", systemImage: sortedTab == .defaultSetting ? "checkmark" : "" )
                                 //   .foregroundColor(sortedTab == .defaultSetting ? .red : .green)
                                 }  //.foregroundColor(sortedTab == .defaultSetting ? .red : .green) */
                            }.foregroundColor(.red)
                            
                            
                            Section(header: Text("Clear Ingredients")){
                                
                                // clear saved recipes
                                Button(action: {
                                    showDeleteIng = true
                                    SettingsView().clearIngredients()
                                    
                                }) {
                                    Label ("Delete All Ingredients", systemImage: "trash")
                                }.foregroundColor(.red)
                                
                            }
                            
                            .alert(isPresented: $showDeleteIng){
                                Alert(title: Text( "Deleting All stored recipes"),
                                      message: Text("Are you sure you want to do this?"),
                                      primaryButton: .destructive(Text("Yes")){
                                    SettingsView().clearIngredients()
                                    showDeleteIng = false
                                }, secondaryButton: .cancel(Text("Cancel"))
                                )
                                
                            }
                            
                            
                        }
                    label: {
                        Label("Add", systemImage: "plus")
                    }
                    }
                }
                
                
                
                .fullScreenCover(isPresented: $showAddItem, onDismiss: nil) {
                    AddItem()
                }
                .fullScreenCover(isPresented: $showScanItem) {
                    ScannerView()
                    // BarcodeScanning(barcode_string: $barcode_string, foundProduct:$foundProduct)
                }
                /** Button(action: {
                 showAddItem = true
                 // self.isPresented.toggle()
                 }) {
                 Image(systemName: "barcode")
                 }.sheet(isPresented: $showScanItem) {
                 ScannerViewUI()
                 //BarcodeScanning(barcode_string: $barcode_string, foundProduct:$foundProduct)
                 } */
                
                //            .fullScreenCover(isPresented: $showScanItem, onDismiss: nil) {
                //               BarcodeScanning(barcode_string: $barcode_string, foundProduct:$foundProduct)
                //         }
                
                /**
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
                 } */
                /**
                 .sheet(isPresented:  $showPopup){
                 AddItem()
                 // NewItemView()
                 } //.padding(.bottom, 10)
                 */
                // Spacer()
                
                
                /** Button(action: generateItems) {
                 { networkModel().getCurrentRecipesIfNeeded { recipes in
                 if let recipes = recipes {
                 print ("Recipes fetched: \(recipes)")
                 } else { print("No recipes")
                 }}
                 }){
                 Text("Generate")
                 .padding()
                 .foregroundColor(.white)
                 .background(buttonStatus ? Color.green : Color.gray)
                 .cornerRadius(15)
                 }
                 .padding()
                 .disabled(!buttonStatus)
                 */
          
                Button(action: {
                    generateItems()
                    navigateToNextPage = true
                }) {
                    Text("Generate")
                        .padding()
                        .foregroundColor(.white)
                        .background(buttonStatus ? Color.green : Color.gray)
                        .cornerRadius(15)
                }
                .padding()
                .disabled(!buttonStatus)
                
                //.background(NavigationLink(destination: NextPage(recipesBasedOnIngredients: recipesBasedOnIngredients), isActive: $navigateToNextPage){})
                .fullScreenCover(isPresented:$navigateToNextPage, onDismiss: nil) {
                    NextPage(recipesBasedOnIngredients: recipesBasedOnIngredients)
                }
            
        }
            .background(Color(UIColor.systemGroupedBackground))
           // .background(Color(UIColor.systemGroupedBackground)) // fixes generate button background!
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
    /*
     func updateIngredientsList() {
        let checkedItems = itemsViewModel.items.filter({ $0.isChecked })
       let ingredientsQuery = checkedItems.map {$0.name}.joined(separator: ",")
         
    } */
    
    //https://vikramios.medium.com/mastering-swift-local-notifications-a-developers-guide-f56b77ab64cc
    private func scheduleNotification(for item: Items) {
        let today = Date()
        let expiryDate = item.expiryDate.dateValue()
        
        guard expiryDate >= today else {
            return
        }
        let daysDifference = Calendar.current.dateComponents([.day], from: today, to: expiryDate).day ?? 0
        
     //   let daysDifference = Calendar.current.dateComponents([.day], from: Date(), to: item.expiryDate.dateValue()).day ?? 0
        
        //if daysDifference 0= 0 || daysDifference <= 3
        if daysDifference >= 0 && daysDifference <= 3 {
            let content = UNMutableNotificationContent()
            content.title = "Your Ingredient is Expiring"
            content.body = "\(item.name) is expiring \(daysDifference == 0 ? "today" : "very soon, use or donate")!"
            content.sound = UNNotificationSound.default
            
            //https://stackoverflow.com/questions/58561877/error-in-trigger-for-notifications-swift
            //var hours = [9, 12, 18]
            /**var triggerDate = DateComponents()
            triggerDate.hour = 11
            triggerDate.minute = 40
            
            var triggerDateAfternoon = DateComponents()
            triggerDateAfternoon.hour = 11
            triggerDateAfternoon.minute = 41
            */
            //can change date
            var triggerDateEvening = DateComponents()
            triggerDateEvening.hour = 6
            triggerDateEvening.minute = 00
            
                /** let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
            let trigger2 = UNCalendarNotificationTrigger(dateMatching: triggerDateAfternoon, repeats: true) */
            let trigger3 = UNCalendarNotificationTrigger(dateMatching: triggerDateEvening, repeats: true)
            
            
           /** let request = UNNotificationRequest(identifier: item.id, content: content, trigger: trigger)
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
            } */
            
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
        let items = selectedItems.joined(separator: ",")
        
        RecipesIngredients().sendRequest(list_of_ingredients: items) { fetchedData in
            DispatchQueue.main.async {
                self.recipesBasedOnIngredients = fetchedData
                let recipeIds = fetchedData.map { $0.id }
                
                getRecipeStep(recipeIds: recipeIds)
                print(recipesBasedOnIngredients)
            }
        }
       /** let selectedItems = itemsViewModel.items.filter { $0.isChecked }.map { $0.name }
        Networking.shared.fetchItemsRecipes(with: selectedItems) { recipes, error in
            if let error = error {
                print("Error fetching items' recipes: \(error.localizedDescription)")
                return
            }
            
            if let recipes = recipes {
                // Handle the fetched recipes here
                print("Fetched recipes: \(recipes)")
            }
        } */
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
        /**
    private func deleteItems(at offsets: IndexSet) {
            var indicesToDelete: [Int] = []
            
            for index in offsets {
                let item = itemsViewModel.items[index]
                if let userID = userID {
                    let db = Firestore.firestore()
                    let collectionRef = db.collection("items").document(userID).collection("Item")
                    
                    collectionRef.whereField("id", isEqualTo: item.id).getDocuments { (querySnapshot, error) in
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
                                    print("Item \(item.name) deleted successfully.")
                                    
                                    // Add the index to the list of indices to delete
                                    indicesToDelete.append(index)
                                }
                            }
                        } else {
                            print("No document found for item \(item.name)")
                        }
                    }
                }
            }
            
            // Remove items from ViewModel after deletion loop
            indicesToDelete.forEach { index in
                itemsViewModel.items.remove(at: index)
            }
        } */
    
    
    private func deleteItem(for item: Items) {
        guard let userID = userID else {
            return
        }
        
        let db = Firestore.firestore()
        let collectionRef = db.collection("items").document(userID).collection("Item")
        
        collectionRef.whereField("id", isEqualTo: item.id).getDocuments { (querySnapshot, error) in
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
                        print("Item \(item.name) deleted successfully.")
                        
                        // Remove item from ViewModel after deletion
                        if let index = itemsViewModel.items.firstIndex(where: { $0.id == item.id }) {
                            itemsViewModel.items.remove(at: index)
                        }
                    }
                }
            } else {
                print("No document found for item \(item.name)")
            }
        }
    }

    
    private func getRecipeStep(recipeIds : [Int]) {
        
        for recipeid in recipeIds {
            RecipesSteps().sendRequest(id_number: recipeid){ fetchedData in
                DispatchQueue.main.async {
                    recipesSteps.append(contentsOf: fetchedData)
                    self.recipesSteps = fetchedData
                    print(recipesSteps)
                }
            }
        }
    }
    
    struct NextPage: View {
        let recipesBasedOnIngredients: [RecipesBasedIngredients]
        
        var body: some View {
            NavigationView {
                List(recipesBasedOnIngredients, id: \.id) { recipeBased in
                    NavigationLink(destination: NextPage1(recipeBased: recipeBased)) {
                        if let photoURL = URL(string: recipeBased.image) {
                            AsyncImage(url: photoURL) { image in
                                image
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(8)
                            } placeholder: {
                                ProgressView()
                            }
                            Text("\(recipeBased.title)")
                            Text("\(recipeBased.id)")
                        }
                    }
                }
            }
        }
        
        struct NextPage1: View {
            let recipeBased: RecipesBasedIngredients
            
            @State private var recipeSteps: [RecipeStep] = []
            
            var body: some View {
                List {
                    Text(recipeBased.title)
                    if let photoURL = URL(string: recipeBased.image) {
                        AsyncImage(url: photoURL) { image in
                            image
                                .resizable()
                                .frame(width: 300, height: 200)
                                .cornerRadius(8)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                    ForEach(recipeSteps, id: \.self) { recipeStep in
                        VStack(alignment: .leading) {
                            Text(recipeStep.name)
                                .font(.headline)
                            ForEach(recipeStep.steps, id: \.self) { step in
                               // let eaching = removeDuplicates(step.ingredients)
                                //ForEach(step.ingredients.filter {ingredient in !step.ingredients.contains(where: { $0.name == ingredient.name })}, id: \.id) { ingredient in
                                //Set
                               // let each = Set(step.ingredients)
                                //let eachArray = Array(each)
                                ForEach(step.ingredients) { ingredient in
                                    Text("\(ingredient.name)")
                                      //  .removeDuplicates()
                                }
                                }
                            ForEach(recipeStep.steps, id: \.self) { step in
                                //                        Text("\(step.ingredients)")
                                Text("\(step.number). \(step.step)")
                                    .padding(.leading)
                            }
                            
                        
                        }
                    }
                    ForEach(recipeBased.missedIngredients, id: \.id){ missedIngredients in
                        Text("Missed Ingredients:   \(missedIngredients.originalName)")
                    }
                    ForEach(recipeBased.usedIngredients, id: \.id){ usedIngredients in
                        Text("Used Ingredients:  \(usedIngredients.originalName)")
                    }
                    
                }
                .navigationTitle(recipeBased.title)
                .onAppear {
                    getRecipeStep(recipeId: recipeBased.id)
                }
            }
            
            private func getRecipeStep(recipeId: Int) {
                RecipesSteps().sendRequest(id_number: recipeId) { fetchedData in
                    DispatchQueue.main.async {
                        recipeSteps = fetchedData
                    }
                }
            }
        }
    }

    
    
    
    
    // https://www.youtube.com/watch?v=FPLQXCmvA7o&ab_channel=PaulHudson
    // https://docs.airnativeextensions.com/docs/firebase/firestore/transactions-and-batched-writes/
    
    // https://www.youtube.com/watch?v=KcOvWU3xp1I&t=273s&ab_channel=JohnGallaugher
    // https://www.youtube.com/watch?v=KMtdBgHwvGY&list=PL9VJ9OpT-IPSM6dFSwQCIl409gNBsqKTe&index=64&ab_channel=JohnGallaugher
   /** private func deleteItems(at offsets: IndexSet) {
        // var itemsToDelete: [Items] = []
        
        //
        for index in offsets {
            let item = itemsViewModel.items[index]
            
            if let userID = userID {
                let db = Firestore.firestore()
                // https://firebase.google.com/docs/firestore/query-data/queries
                // https://firebase.google.com/docs/firestore/solutions/swift-codable-data-mapping
                //https://peterfriese.dev/blog/2020/swiftui-firebase-fetch-data/
           // https://www.youtube.com/watch?v=KcOvWU3xp1I&list=PL9VJ9OpT-IPSM6dFSwQCIl409gNBsqKTe&index=102&ab_channel=JohnGallaugher??
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
                                
                                // https://stackoverflow.com/questions/71391214/how-to-remove-pending-notification-request-when-using-uuidstring-as-identifier-s
                                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [item.id])
                                
                                
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
    } */
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
    @EnvironmentObject var itemsViewModel: ItemsViewModel
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
                if !item.imageURL.isEmpty{
                    Section(header: Text("IMAGE")){
                        HStack{
                            Spacer()
                            KFImage(URL(string: "\(item.imageURL)")!)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 240, height: 240)
                                .background()
                            Spacer()
                        }
                        .background(Color(UIColor.systemGroupedBackground))
                    }
                    .background(Color(UIColor.systemGroupedBackground))
                }

                
                Section(header: Text("Ingredient name")) {
                    Text(" \(item.name)")
                }
                
                Section(header: Text("Quantity")) {
                    Text("\(item.quantity)")
                }
                
                Section(header: Text("Expiry date")) {
                    Text("\(expiryDateFormatter)")
                }
                
                Section(header: Text("Category")) {
                    Text("\(item.selection)")
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
                
                Button(action: {
                    deleteItem(for: item)
                }) {
                    Text("Delete Ingredient")
                        .foregroundColor(.red)
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
    
    private func deleteItem(for item: Items) {
        var userID: String? {
            return Auth.auth().currentUser?.uid }
        
        guard let userID = userID else {
            return
        }
        
        let db = Firestore.firestore()
        let collectionRef = db.collection("items").document(userID).collection("Item")
        
        collectionRef.whereField("id", isEqualTo: item.id).getDocuments { (querySnapshot, error) in
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
                        print("Item \(item.name) deleted successfully.")
                        
                        // Remove item from ViewModel after deletion
                        if let index = itemsViewModel.items.firstIndex(where: { $0.id == item.id }) {
                            itemsViewModel.items.remove(at: index)
                        }
                    }
                }
            } else {
                print("No document found for item \(item.name)")
            }
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}



#Preview {
    ListView()
        //.environmentObject(itemsViewModel)
}




