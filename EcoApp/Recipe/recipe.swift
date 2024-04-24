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
    let label: String
    let image: String
    let totalTime: Float
    let cuisineType: [String]
    let ingredientLines: [String]
    let url: String
}


//struct Recipe : Codable {
//    let title: String
//    let ingredients: String
//    let servings: String
//    let instructions: String
//}
