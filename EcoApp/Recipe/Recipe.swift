//
//  Recipe.swift
//  EcoApp
//
//  Created by Saajidah Mohamed
//

import Foundation


struct RecipeData: Decodable {
    let hits: [Hit]
}

struct Hit: Decodable {
    let recipe: Recipe
}

struct Recipe: Decodable {
// let id: String
    let label: String
    let image: String
    let totalTime: Float
    let cuisineType: [String]
   // let dietLabels: [String]
    let ingredientLines: [String]
    let url: String
}


