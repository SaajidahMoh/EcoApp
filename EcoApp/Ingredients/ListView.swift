//
//  ListView.swift
//  EcoApp
//
//  Created by Saajidah Mohamed 
//

import SwiftUI
import Firebase
import UserNotifications
import Kingfisher
import UIKit

struct ListView: View {
    @AppStorage("log_status") private var logStatus: Bool = false
    @EnvironmentObject var itemsViewModel: ItemsViewModel
    @State private var showPopup = false
    @State private var showAddItem = false
    @State private var showScanItem = false
    @State private var showDeleteIng = false
    @State private var navigateToNextPage = false
    
    // barcode string and found product was reused and adapted from: https://www.youtube.com/watch?v=44APgBnapag&ab_channel=BrianAdvent
    @State private var barcode_string: String?
    @State private var foundProduct: Product?
    
    @State private var recipesBasedOnIngredients : [RecipesBasedIngredients] = []
    @State private var recipesSteps: [RecipeStep] = []
    
    /*
     * Sort items, sorted tab and tab were adapted from the article below to implement filtering.
     * Xavier (2023), SwiftUI List with Sort Options. Published: iOS Devx. Link available at: https://xavier7t.com/swiftui-list-with-sort-options
     * Source code available at: https://github.com/xavier7t/iOSDevX/blob/main/iOSDevX/202303-Mar%202023/Sort%20Options/ContentView-DemoSortOptions20230320.swift
     */
  
    
    @State private var sortedTab: Tab = .expiryDate
    
    enum Tab: String, CaseIterable{
        case expiryDate
        case category
    }
    
    var sortedItems:[Items]{
        switch sortedTab {
        case .expiryDate:
            // convert expiry date in format timestamp to date and sort.
            return itemsViewModel.items.sorted(by: {$0.expiryDate.dateValue() < $1.expiryDate.dateValue() })
        case .category:
            // let sort by expiry date be the default sorting
            return itemsViewModel.items.sorted(by:{$0.expiryDate.dateValue() < $1.expiryDate.dateValue() })
        }
    }
    
    var userID: String? {
        return Auth.auth().currentUser?.uid }
    
    var body: some View {
        NavigationView {
            VStack {
                
                List {
                    if sortedTab == .category {
                        
                        // New list of categories without duplicates
                        let categList = Set(sortedItems.map { $0.selection })
                        
                        // Sort items for each list
                        ForEach(categList.sorted(), id: \.self) { category in
                            let eachItem = sortedItems.filter { $0.selection == category }
                            
                            Section(header: Text(category)) {
                                ForEach(eachItem, id: \.id) { item in
                                    ItemRow(item: item)
                                        .environmentObject(itemsViewModel)
                                        .onAppear {
                                            // schedule notifications for the items
                                            scheduleNotification(for: item)
                                        }
                                    
                                    /**
                                     * The swipe action was implemented to allow users to delete by swiping, replicating a real ios application.
                                     * Friese, P (2021) ,Swipe Actions in SwiftUI 3. The Ultimate Guide to SwiftUI List Views - Part 4
                                     * Link available at: https://peterfriese.dev/blog/2021/swiftui-listview-part4/
                                     */
                                        .swipeActions {
                                            Button("Delete"){
                                                deleteItem(for: item)
                                            }
                                            .tint(.red)
                                        }
                                }
                            }
                        }
                    } else {
                        // If not sorted by category, display items without sections
                        ForEach(sortedItems, id: \.id) { item in
                            ItemRow(item: item)
                                .environmentObject(itemsViewModel)
                                .onAppear {
                                    // schedule notifications for the items
                                    scheduleNotification(for: item)
                                } 
                    
                            /**
                             * The swipe action was reused and implemented to allow users to delete by swiping, replicating a real ios application.
                             * Friese, P (2021) ,Swipe Actions in SwiftUI 3. The Ultimate Guide to SwiftUI List Views - Part 4
                             * Link available at: https://peterfriese.dev/blog/2021/swiftui-listview-part4/
                             */
                                .swipeActions {
                                    Button("Delete"){
                                        deleteItem(for: item)
                                    }
                                    // .background(Color.red)
                                    .tint(.red)
                                }
                        }
                    }
                }
                
                .navigationTitle("Ingredients")
                
                /**
                 * The toolbar was reused and adapted to implement a wide range of menus.
                 * Jabrayilov, M. (2020), Menus in SwiftUI. Published: Swift with Majid.
                 * Link available at: https://swiftwithmajid.com/2020/08/05/menus-in-swiftui/
                 */
                
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
                                }
                                Button(action: {sortedTab = .category}) {
                                    Label("Sort By Category", systemImage: sortedTab == .category ? "checkmark" : "list.star")
                                }
                            }
                            .foregroundColor(.red)
                            
                            
                            Section(header: Text("Clear Ingredients")){
                                
                                // clear saved recipes
                                Button(action: {
                                    showDeleteIng = true
                                    Settings().clearIngredients()
                                    
                                }) {
                                    Label ("Delete All Ingredients", systemImage: "trash")
                                }.foregroundColor(.red)
                                
                            }
                            
                            .alert(isPresented: $showDeleteIng){
                                Alert(title: Text( "Deleting All Stored Ingredients"),
                                      message: Text("Are you sure you want to do this?"),
                                      primaryButton: .destructive(Text("Yes")){
                                    Settings().clearIngredients()
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
                }
                
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
                
                .fullScreenCover(isPresented:$navigateToNextPage, onDismiss: nil) {
                    RecipeView(recipesBasedOnIngredients: recipesBasedOnIngredients)
                }
                
            }
            // code reuse to fix the white bacground of the generate button https://stackoverflow.com/questions/59149705/how-to-set-the-background-color-of-a-swiftui-to-lightgray
            .background(Color(UIColor.systemGroupedBackground))
        }
    }
    /**
     * The schedule notification funciton was reused and adapted to set local notiifcation on the mobile phone.
     * Kumar, V. (2023) Mastering Swift Local Notifications: A Developer’s Guide - Unlocking the Power of User Engagement with Swift’s Local Notification System. Published: Medium.
     * Link Available at : https://vikramios.medium.com/mastering-swift-local-notifications-a-developers-guide-f56b77ab64cc
     */
    private func scheduleNotification(for item: Items) {
        let today = Date()
        let expiryDate = item.expiryDate.dateValue()
        
        guard expiryDate >= today else {
            return
        }
        /**
         * The days difference constant was reused and adapted from the article to calculate the difference between the days.
         * Hudson, P. (2023), Working with dates. Article available at : https://www.hackingwithswift.com/books/ios-swiftui/working-with-dates
         */
        // Calculate the difference in days between today and the expiry date, if there is no different then output 0
        let daysDifference = Calendar.current.dateComponents([.day], from: today, to: expiryDate).day ?? 0
        
        // set notifications for ingredients expiring from tommorow to 3 days.
        if daysDifference >= 0 && daysDifference <= 3 {
            let content = UNMutableNotificationContent()
            content.title = "Your Ingredient is Expiring"
            // personalise notification based on expiry date
            content.body = "\(item.name) is expiring \(daysDifference == 0 ? "today" : "very soon, use or donate")!"
            content.sound = UNNotificationSound.default
            
            // notification time
            var triggerDateEvening = DateComponents()
            triggerDateEvening.hour = 6
            triggerDateEvening.minute = 00
            
            // repeats notification every day
            let trigger3 = UNCalendarNotificationTrigger(dateMatching: triggerDateEvening, repeats: true)
            
            // sets the notification
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
    
    // checks if any items is selected
    private var buttonStatus: Bool {
        let status = itemsViewModel.items.contains { $0.isChecked }
        print("Button status: \(status)")
        return status
    }
    
    /**
     * Generate items was reused and adapted from the video below to get the list of selected items and make the api call to get the list on recipes based on the items selected.
     * Advent, B. (2020) iOS Swift Tutorial: Use APIs with Swift UI & Build a Book Barcode Scanner. Link available at: https://www.youtube.com/watch?v=44APgBnapag&ab_channel=BrianAdvent
     * Source code: https://www.patreon.com/posts/42828807
     */
    
    // puts the ingredients in a list. e.g, 'egg, butter and milk' will become 'egg,butter,milk'.
    private func generateItems() {
        let selectedItems = itemsViewModel.items.filter { $0.isChecked }.map { $0.name }
        let items = selectedItems.joined(separator: ",")
        
        RecipesIngredients().sendRequest(list_of_ingredients: items) { fetchedData in
            DispatchQueue.main.async {
                self.recipesBasedOnIngredients = fetchedData
                let recipeIds = fetchedData.map { $0.id }
                
                print(recipesBasedOnIngredients)
            }
        }
    }

    private func deleteItem(for item: Items) {
        guard let userID = userID else {
            return
        }
        // code below was reused and developed to find the document of where the item is stored. https://peterfriese.dev/blog/2020/swiftui-firebase-fetch-data/
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
            // if there is 2 unique id's of items that are the same, it would get the first to delete.
            if let document = documents.first {
                let documentID = document.documentID
                collectionRef.document(documentID).delete { error in
                    if let error = error {
                        print("Error deleting item \(item.name): \(error.localizedDescription)")
                    } else {
                        print("Item \(item.name) deleted successfully.")
                        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [item.id])
                        
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
    
    /**
     * The design of the recipe was reused and adapted to make the interface replicate my figma wireframe.
     * Petras, R. (2021). Let's Design the Recipe Cards with SwiftUI and Present all the Recipes - Part 12. Youtube video available at: https://www.youtube.com/watch?v=8CbUTZPPNT4&ab_channel=CredoAcademy
     */
    
    /**
     * The recipe view was reused and adapted to get all the recipe names and images. When selected, it would navigate to the recipe instruct view to also show the specific recipes ingredients and instructions.
     * Hudson, P. (2022) How to push a new view when a list row is tapped. Published at: Hacking With Swift. Link avaliable at: https://www.hackingwithswift.com/quick-start/swiftui/how-to-push-a-new-view-when-a-list-row-is-tapped
     */
    
    struct RecipeView: View {
        @Environment(\.presentationMode) var presentationMode
        let recipesBasedOnIngredients: [RecipesBasedIngredients]
        
        var body: some View {
            NavigationView {
                
                ScrollView{
                    VStack{
                        ForEach(recipesBasedOnIngredients, id: \.id) { recipeBased in
                        NavigationLink(destination: RecipeInstructView(recipeBased: recipeBased)) {
                            VStack(alignment: .leading, spacing: 10) {
                                
                                /**
                                 * The image code was reused to display remote images in the app.
                                 * Moiseienko, M. (2023), SwiftUI: Efficient Image Loading using AsyncImage. Link available at: https://m-mois.medium.com/swiftui-efficient-image-loading-using-asyncimage-a059fe4efc34
                                 */
                                if let photoURL = URL(string: recipeBased.image) {
                                    AsyncImage(url: photoURL) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 350, height: 120)
                                            .clipped()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                }
                                
                                Text(recipeBased.title)
                                    .font(.headline)
                                    .padding(.horizontal)
                            }
                            
                            .padding(.horizontal, 0)
                            .padding(.vertical, 10)
                            .background(Color(.systemGray5))
                        }
                        .buttonStyle(PlainButtonStyle())
                        .listRowSeparator(.hidden)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    .listStyle(PlainListStyle())
                    }
                    
                    .navigationBarItems(leading: Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.green)
                    })
                    .navigationBarTitle("Generated Recipes", displayMode: .inline)
                    
                }.background(Color(UIColor.systemGroupedBackground)) // background
                    .padding(.trailing, -5)
                    .padding(.leading, -5)
            }
        }
        
        /**
         * The design of the recipe was reused and adapted to make the interface replicate my figma wireframe.
         * Petras, R. (2021). Let's Design the Recipe Cards with SwiftUI and Present all the Recipes - Part 12. Youtube video available at: https://www.youtube.com/watch?v=8CbUTZPPNT4&ab_channel=CredoAcademy
         */
        
        /**
         * The recipe instruct view was reused and adapted to get the recipes name, image, ingredients and instructions.
         * Hudson, P. (2022) How to push a new view when a list row is tapped. Published at: Hacking With Swift. Link avaliable at: https://www.hackingwithswift.com/quick-start/swiftui/how-to-push-a-new-view-when-a-list-row-is-tapped
         */
                     
        struct RecipeInstructView: View {
            let recipeBased: RecipesBasedIngredients
            
            @State private var recipeSteps: [RecipeStep] = []
            
            var body: some View {
                ScrollView(.vertical, showsIndicators: false){
                    VStack {
                        /**
                         * The image code was reused to display remote images in the app.
                         * Moiseienko, M. (2023), SwiftUI: Efficient Image Loading using AsyncImage. Link available at: https://m-mois.medium.com/swiftui-efficient-image-loading-using-asyncimage-a059fe4efc34
                         */
                        if let photoURL = URL(string: recipeBased.image) {
                            AsyncImage(url: photoURL) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .clipped()
                                    .padding(.leading)
                                    .padding(.trailing)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        
                       // HStack {
                            Group {
                                Text(recipeBased.title)
                                    .font(.system(.title))
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color (.systemGreen))
                                    .padding(.top, 10)
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            Spacer()
                           /*
                            Button(action: shareRecipe
                            ){
                                Image(systemName: "square.and.arrow.up")
                                    .resizable()
                                    .frame(width: 21, height: 30)
                                    .padding(10)
                                    .foregroundColor(.green)
                            } */
                      //  }
                 
                        VStack(alignment: .leading, spacing: 6){
                            
                            if !recipeBased.usedIngredients.isEmpty {
                                Text("Used Ingredients")
                                    .fontWeight(.bold)
                                    .font(.system(size: 24))
                                    .padding(.leading)
                                    .padding(.trailing)
                                
                                
                                ForEach(recipeBased.usedIngredients, id: \.id){ usedIngredients in
                                    Text("\(usedIngredients.original.replacingOccurrences(of: ",", with: ""))")
                                        .font(.system(size: 18))
                                    Divider()
                                } .padding(.leading)
                                    .padding(.trailing)
                                
                            }
                            
                            if !recipeBased.missedIngredients.isEmpty {
                                Text("Missed Ingredients")
                                    .fontWeight(.bold)
                                    .font(.system(.title2))
                                    .padding(.leading)
                                    .padding(.trailing)
                                    .padding(.top, 10)
                                
                                // remove everything after comma, e.g 2 eggs, slow cooked = 2 eggs.
                                ForEach(recipeBased.missedIngredients, id: \.id){ missedIngredients in
                                    let noComma = missedIngredients.original.hasSuffix(",") ? String(missedIngredients.original.dropLast()) : missedIngredients.original
                                    Text("\(noComma)")
                                        .font(.system(size: 18))
                                    Divider()
                                    
                                }
                                .padding(.leading)
                                .padding(.trailing)
                            }
                            
                            Text("Instructions")
                                .fontWeight(.bold)
                                .font(.system(.title2))
                                .padding(.top, 10)
                                .padding(.leading)
                                .padding(.trailing)
                            
                            ForEach(recipeSteps, id: \.self) { recipeStep in
                                ForEach(recipeStep.steps, id: \.self) { step in
                                    Text("\(step.number). \(step.step)")
                                        .font(.system(size: 16))
                                    Divider()
                                }
                            }
                            .padding(.leading)
                            .padding(.trailing)
                        }
                    }
                    
                    .onAppear {
                        getRecipeInstructions(recipeId: recipeBased.id)
                    }
                    .padding(.leading, 8)
                    .padding(.trailing, 8)
                }
            }
            
            /** The get recipe instructions was reused and adaptedfrom the video below to do an API call to get the results from the API and store it into recipe steps.
             * Advent, B. (2020) iOS Swift Tutorial: Use APIs with Swift UI & Build a Book Barcode Scanner. Link available at: https://www.youtube.com/watch?v=44APgBnapag&ab_channel=BrianAdvent
             * Source code: https://www.patreon.com/posts/42828807
             */
            private func getRecipeInstructions(recipeId: Int) {
                RecipesSteps().sendRequest(id_number: recipeId) { fetchedData in
                    DispatchQueue.main.async {
                        recipeSteps = fetchedData
                    }
                }
            }
            
            // code was reused was chatgpt to allow screenshot of page, and sharing of the screenshot. https://chat.openai.com/share/75ea5027-cdf4-4dd8-b320-9f6173f65149
            func takeScreenshot() -> UIImage? {
                guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
                      let rootView = window.rootViewController?.view else {
                    return nil
                }
                
                let renderer = UIGraphicsImageRenderer(size: rootView.bounds.size)
                let screenshot = renderer.image { context in
                    rootView.drawHierarchy(in: rootView.bounds, afterScreenUpdates: true)
                }
                
                return screenshot
            }

            func shareRecipe() {
                if let screenshot = takeScreenshot() {
                    let activityViewController = UIActivityViewController(activityItems: [screenshot], applicationActivities: nil)
                    UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    // https://www.youtube.com/watch?v=FPLQXCmvA7o&ab_channel=PaulHudson
    // https://docs.airnativeextensions.com/docs/firebase/firestore/transactions-and-batched-writes/
    
    // https://www.youtube.com/watch?v=KcOvWU3xp1I&t=273s&ab_channel=JohnGallaugher
    // https://www.youtube.com/watch?v=KMtdBgHwvGY&list=PL9VJ9OpT-IPSM6dFSwQCIl409gNBsqKTe&index=64&ab_channel=JohnGallaugher
     // https://firebase.google.com/docs/firestore/query-data/queries
     // https://firebase.google.com/docs/firestore/solutions/swift-codable-data-mapping
     //https://peterfriese.dev/blog/2020/swiftui-firebase-fetch-data/
     // https://www.youtube.com/watch?v=KcOvWU3xp1I&list=PL9VJ9OpT-IPSM6dFSwQCIl409gNBsqKTe&index=102&ab_channel=JohnGallaugher??
    
      
}


// shows all the items with the checked circles and updates if the item is checked.
struct ItemRow: View {
    let item: Items
    @EnvironmentObject var itemsViewModel: ItemsViewModel
    @State private var isChecked: Bool = false
    @State private var isShown = false
   
    /**
     * The expiry date formatter variable was reused and adapted from the article to display the date as I wanted.
     * Ng, P (2020), [Swift] Work With Dates #1 Basic Types: Date, DateFormatter, DateComponent. Published: Medium. Article available at: https://medium.com/swlh/swift-working-with-dates-1-basic-types-date-dateformatter-datecomponent-4bfc376ee93b
     */
    private var expiryDateFormatter: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: item.expiryDate.dateValue())
    }
    
    /**
     * The constants with the 'let' infront in the expiry date status variable were reused and adapted from the article below to calculate the days accurately so that if the days difference is 1 it should only mean tomorrow and not also yesterday.
     * Wongpatcharapakorn, S. (2020), Getting the number of days between two dates in Swift. Article available at : https://sarunw.com/posts/getting-number-of-days-between-two-dates/
     */
    private var expiryDateStatus: String {
        //setting the day so it accurately displays the date
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let expiryDate = calendar.startOfDay(for: item.expiryDate.dateValue())
        let daysDifference = Calendar.current.dateComponents([.day], from: today, to: expiryDate).day ?? 0
        
        // accurately displays the status of expiry
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
    
    /**
     * The days difference constant was reused and adapted from the article to calculate the difference between the days.
     * Hudson, P. (2023), Working with dates. Article available at : https://www.hackingwithswift.com/books/ios-swiftui/working-with-dates
     */
    private func expiryDateRed() -> Color {
        // Calculate the difference in days between today and the expiry date, if there is no different then output 0
        let daysDifference = Calendar.current.dateComponents([.day], from: Date(), to: item.expiryDate.dateValue()).day ?? 0
        
        // If the expiry date is within 3 days from today, return red, if between 2-4 days return yellow else the default colour
        if daysDifference <= 0 {
            return .red
        } else if daysDifference <= 3 {
            return .yellow
        } else {
            return .primary // set to primary so it's visible in dark code.
        }
    }
    
    var body: some View {
        HStack {
            Image(systemName: isChecked ? "circle.inset.filled" : "circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:22, height: 22)
            
            // fill circle to green if item is selected
                .foregroundColor(isChecked ? .green : .gray)
                .onTapGesture {
                    isChecked.toggle()
                    itemsViewModel.updateItem(itemID: item.id, isChecked: isChecked) // update status of the item selected.
                    print("\(item.name) checked : \(isChecked)")
                }
                .padding(.trailing, 8)
            
            Text(item.name)
                .font(.headline)
            
            Text("Qty: \(item.quantity)")
                .font(.subheadline)
            
            Spacer()
            
            Text(expiryDateStatus)
                .font(.subheadline)
                .foregroundColor(expiryDateRed())
            
            Image(systemName: "info.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:20, height: 20)
                .padding(.leading, 8)
            
                .onTapGesture {
                    isShown.toggle()
                }
                .foregroundColor(Color.green)
            // shows the view of the item
                .fullScreenCover(isPresented: $isShown, onDismiss: nil) {
                    EachItemView(item: item)
                }
        }
    }
}

struct EachItemView: View {
    
    let item: Items
    @State private var editShown = false
    @EnvironmentObject var itemsViewModel: ItemsViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    /**
     * The expiry date formatter variable was reused and adapted from the article to display the date as I wanted.
     * Ng, P (2020), [Swift] Work With Dates #1 Basic Types: Date, DateFormatter, DateComponent. Published: Medium. Article available at: https://medium.com/swlh/swift-working-with-dates-1-basic-types-date-dateformatter-datecomponent-4bfc376ee93b
     */
    private var expiryDateFormatter: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        return dateFormatter.string(from: item.expiryDate.dateValue())
    }
    
    var body: some View{
        NavigationView {
            /**
             * The form was reused and adapted from a swiftui form video.
             * Allen, S. (2021), SwiftUI Form w/ TextField, DatePicker, Toggle, Stepper, Link and Sections w/ Header.
             * Youtube video available at: https://www.youtube.com/watch?v=m0QQ-hWs8fc&t=31s&ab_channel=SeanAllen
             */
            Form {
                // if image is not empty, show image
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
                        // background colour
                        .background(Color(UIColor.systemGroupedBackground))
                    }
                    // background colour
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
                
                if !item.description.isEmpty {
                    Section(header: Text("Description")) {
                        Text("\(item.description)")
                    }
                }
                
                // delete ingredient button
                Button(action: {
                    deleteItem(for: item)
                }) {
                    Text("Delete Ingredient")
                        .foregroundColor(.red)
                }
            }
            
            .navigationTitle("Ingredient Details")
            
            // left arrow to go back to the view of all items
            .navigationBarItems(leading: Button(action : {
                self.presentationMode.wrappedValue.dismiss()
            }, label : {
                Image(systemName: "arrow.left")
                    .foregroundColor(.green)
            }),
                                // edit button
                                trailing: Button(action: {
                editShown.toggle()
            }, label: {
                Image(systemName: "rectangle.and.pencil.and.ellipsis")
                    .foregroundColor(.green)
            }))
            
            // navigates to the view of edit item
            .sheet(isPresented: $editShown, onDismiss: nil) {
                EditItem(item: item)
            }
        }
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
        /**
         * The remove pending notifications were reused to remove notifications for the item deleted.
         * https://stackoverflow.com/questions/71391214/how-to-remove-pending-notification-request-when-using-uuidstring-as-identifier-s
         */
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [item.id])
        presentationMode.wrappedValue.dismiss()
    }
}



#Preview {
    ListView()
    //.environmentObject(itemsViewModel)
}




