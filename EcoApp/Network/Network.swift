//
//  Network.swift
//  EcoApp
//
//  Created by Saajidah Mohamed
//

import Foundation

/**
 * networkModel, barcodeToWord, RecipesIngredients and RecipesSteps were code thats were resued and adapted based on the different object types from RapidAPI. I downloaded RapidAPI and used the url and url parameters (under URLParams) to get the correct information. After the success '200' status code, there should be code below the url parameters section, switch to "Swift NSURLSession" and the code is there. Json data and product data was also reused from the video provided below.
 * Advent, B. (2020) iOS Swift Tutorial: Use APIs with Swift UI & Build a Book Barcode Scanner. Link available at: https://www.youtube.com/watch?v=44APgBnapag&ab_channel=BrianAdvent
 * Source code: https://www.patreon.com/posts/42828807
 */

class networkModel {
    
    func sendRequest(searchTerm :String,completion : @escaping (RecipeData) -> Void ) {
        
        // configure session
        let sessionConfig = URLSessionConfiguration.default
        
        // Create session, and optionally set a URLSessionDelegate.
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        // Create the Request: searchingredient (GET https://api.spoonacular.com/recipes/findByIngredients)
        
        guard var URL = URL(string: "https://api.edamam.com/api/recipes/v2") else {return}
        let URLParams = [
            "type": "public",
            "q": "\(searchTerm)",
            "app_id": "1291286b",
            "app_key": "61c071f471412a3b577915de627c1ed2",
        ]
        URL = URL.appendingQueryParameters(URLParams)
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        
        // Start a new Task
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
                
                guard let jsonData = data else {return}
                do {
                    let productData = try JSONDecoder().decode(RecipeData.self, from: jsonData)
                    completion(productData)
                    //print(productData)
                } catch {
                    print(error)
                }
            }
            else {
                // Failure
                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
}

class barcodeToWord {
    func getProductName(barcode :String,completion : @escaping (Product) -> Void ) {
        // configure session
        let sessionConfig = URLSessionConfiguration.default
        
        // Create session, and optionally set a URLSessionDelegate.
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        // Create the Request: searchingredient (GET https://world.openfoodfacts.org/api/v2/product)
        guard var URL = URL(string: "https://world.openfoodfacts.org/api/v2/product/\(barcode)") else {return}
        let URLParams = [
            "fields": "product_name",
        ]
        URL = URL.appendingQueryParameters(URLParams)
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        
        // Start a new Task
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
                
                // gets that json data and uses JSONDecoder to parse the json data (decoding JSON data into of Product type) and store it in productdata
                guard let jsonData = data else {return}
                do {
                    let productData = try JSONDecoder().decode(Product.self, from: jsonData)
                    completion(productData)
                } catch {
                    print(error)
                }
            }
            else {
                // Failure
                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
}

class RecipesIngredients {
    func sendRequest(list_of_ingredients: String,completion : @escaping ([RecipesBasedIngredients]) -> Void ) {
        // Configure session
        let sessionConfig = URLSessionConfiguration.default
        
        // Create session, and optionally set a URLSessionDelegate.
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        // Create the Request:searchingredient (GET https://api.spoonacular.com/recipes/findByIngredients)
        guard var URL = URL(string: "https://api.spoonacular.com/recipes/findByIngredients") else {return}
        let URLParams = [
            "apiKey": "a36ca5c2f95547b88e4240bba6d5d5e1",
            // "46e5215a20bb4ee2b7fba5d012aa51bf",
            // "5d02e682a92f44c3861e5147d77a1c3c"
            // "dc438687bc2f4a399388154d2ccb8709"
            "ingredients": "\(list_of_ingredients)",
        ]
        URL = URL.appendingQueryParameters(URLParams)
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        
        /* Start a new Task */
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
                
                guard let jsonData = data else {return}
                do {
                    let productData = try JSONDecoder().decode([RecipesBasedIngredients].self, from: jsonData)
                    completion(productData)
                    //                    print(productData)
                } catch {
                    print(error)
                }
            }
            else {
                // Failure
                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
}


class RecipesSteps {
    func sendRequest(id_number :Int, completion : @escaping ([RecipeStep]) -> Void) {
        // Configure session
        let sessionConfig = URLSessionConfiguration.default
        
        // Create session, and optionally set a URLSessionDelegate.
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        // Create the Request: searchingredient (GET https://api.spoonacular.com/recipes/715447/analyzedInstructions)
        let id = String(id_number)
        guard var URL = URL(string: "https://api.spoonacular.com/recipes/\(id)/analyzedInstructions") else {return}
        let URLParams = [
            "apiKey": "a36ca5c2f95547b88e4240bba6d5d5e1",
            // "46e5215a20bb4ee2b7fba5d012aa51bf",
            // "5d02e682a92f44c3861e5147d77a1c3c"
            // "dc438687bc2f4a399388154d2ccb8709"
            
        ]
        URL = URL.appendingQueryParameters(URLParams)
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        
        // Start a new Task
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
                
                guard let jsonData = data else {return}
                do {
                    let productData = try JSONDecoder().decode([RecipeStep].self, from: jsonData)
                    completion(productData)
                } catch {
                    print(error)
                }
            }
            else {
                // Failure
                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
}



protocol URLQueryParameterStringConvertible {
    var queryParameters: String {get}
}

extension Dictionary : URLQueryParameterStringConvertible {
    /**
     This computed property returns a query parameters string from the given NSDictionary. For
     example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
     string will be @"day=Tuesday&month=January".
     @return The computed parameters string.
     */
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = String(format: "%@=%@",
                              String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                              String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }
    
}

extension URL {
    /**
     Creates a new URL by adding the given query parameters.
     @param parametersDictionary The query parameter dictionary to add.
     @return A new URL.
     */
    func appendingQueryParameters(_ parametersDictionary : Dictionary<String, String>) -> URL {
        let URLString : String = String(format: "%@?%@", self.absoluteString, parametersDictionary.queryParameters)
        return URL(string: URLString)!
    }
}
