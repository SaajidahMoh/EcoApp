//
//  Barcode.swift
//  EcoApp
//
//  Created by Saajidah Mohamed on
//

import Foundation

/**
 * The code below was reused and adapted to present the scanner for items.
 * Advent, B. (2020), Tutorial: Use APIs with Swift UI & Build a Book Barcode Scanner. YouTube video available at: https://www.youtube.com/watch?v=44APgBnapag&ab_channel=BrianAdvent
 */

struct Product: Decodable {
    let code: String
    let product: ProductInfo
    let status: Int
    let status_verbose: String
}

struct ProductInfo: Decodable {
    let product_name: String
}
