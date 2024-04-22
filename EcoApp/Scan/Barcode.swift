//
//  Barcode.swift
//  barcode_scanner
//
//  Created by Saajidah Mohamed on 03/04/2024.
// https://www.youtube.com/watch?v=44APgBnapag&ab_channel=BrianAdvent
// https://www.patreon.com/posts/xcode-project-42828807

import Foundation


struct Product: Decodable {
    let code: String
    let product: ProductInfo
    let status: Int
    let status_verbose: String
}

struct ProductInfo: Decodable {
    let product_name: String
}
