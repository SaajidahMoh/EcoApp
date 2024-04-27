//
//  searchIngredients.swift
//  EcoApp
//
//  Created by Saajidah Mohamed on 23/04/2024.
//

import Foundation


struct RecipesBasedIngredients: Decodable {
    let id: Int
    let title: String
    let image: String
    let missedIngredientCount: Int
    let missedIngredients: [Ingredients]
    let usedIngredients: [Ingredients]

}

struct Ingredients: Decodable {
    let id: Int
    let original: String
    let originalName: String

   // static func == (lhs: Ingredients, rhs: Ingredients) -> Bool {
   //         return lhs.originalName == rhs.originalName
    //    }
}

struct RecipeStep: Decodable, Hashable {
    let name: String
    let steps: [Step]
}

struct Step: Decodable, Hashable {
    let number: Int
    let step: String
    let ingredients: [Ingredient]
    
}

struct Ingredient : Decodable, Identifiable, Hashable {
    let id: Int
    let name: String
    let localizedName: String
}
