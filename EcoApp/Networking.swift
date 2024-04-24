//
//  Networking.swift
//  Foodpedia
//
//  Created by Frankie Murillo on 11/14/21.
//
/**
import SwiftUI
import FirebaseAuth


class Networking {
    private var dataTask: URLSessionDataTask?

    static let shared = Networking()

    private init() {}

    func fetchItemsRecipes(with itemNames: [String], completion: @escaping ([[String: Any]]?, Error?) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(nil, NSError(domain: "Networking", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not logged in"]))
            return
        }

        // Construct the URL to fetch items' recipes based on item names and user ID
        //var url = "YOUR_API_ENDPOINT/itemsRecipes?userID=\(userID)&items="
        let baseURL = "https://api.spoonacular.com"
        let endpoint = "/recipes/findByIngredients"
        let apiKey = "0bb74debbf10414cadeea785324753f9"
        
        //var url = "0bb74debbf10414cadeea785324753f9/itemsRecipes?userID=\(userID)&items="
        var url = "\(baseURL)\(endpoint)?apiKey=\(apiKey)&ingredients="

        for itemName in itemNames {
            url += "\(itemName),"
        }
        url = String(url.dropLast())

        
        guard let url = URL(string: url) else {
            completion(nil, NSError(domain: "Networking", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }

            do {
                // Parse the JSON data into an array of dictionaries
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    completion(jsonArray, nil)
                } else {
                    completion(nil, NSError(domain: "Networking", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to parse JSON"]))
                }
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
}
*/
