//
//  recipe.swift
//  EcoApp
//
//  Created by Saajidah Mohamed on 14/04/2024.
//

import Foundation


struct RecipeData: Decodable {
    let hits: [Hit]
}

struct Hit: Decodable {
    let recipe: Recipe
}

struct Recipe: Decodable {
//let id: String
    let label: String
    let image: String
    let totalTime: Float
    let cuisineType: [String]
    let ingredientLines: [String]
    let url: String
}

/**
// Foodpedia
struct ReceipeModel : Codable , Hashable{
    
    let id : Int
    let title : String
    let image : String
    let likes : Int
    let usedIngredients : [ReceipeIngredient]
    let missedIngredients : [ReceipeIngredient]
    
}

//Foodpedia
struct ReceipeIngredient : Codable , Hashable {
    let id : Int
    let amount : Double
    let unit : String
    let name : String
    let image : String
    let aisle : String
}


//struct Recipe : Codable {
//    let title: String
//    let ingredients: String
//    let servings: String
//    let instructions: String
//}
*/
