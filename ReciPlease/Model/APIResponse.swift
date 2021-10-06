//
//  APIResponse.swift
//  ReciPlease
//
//  Created by Adrien PEREA on 05/10/2021.
//

import Foundation

// MARK: - Search
struct APIResponse: Codable {
    let count: Int
    var links: SearchLinks
    var hits: [Hit]

    enum CodingKeys: String, CodingKey {
        case count
        case links = "_links"
        case hits
    }
}

// MARK: - SearchLinks
struct SearchLinks: Codable {
    var next: Next
}

// MARK: - Next
struct Next: Codable {
    var href: String
}

// MARK: - Hit
struct Hit: Codable {
    let recipe: Recipe
}

// MARK: - Recipe
struct Recipe: Codable {
    let uri: String
    let label: String
    let image: String
    let url: String
    let yield: Int
    let ingredientLines: [String]
    let totalTime: Int
    let ingredients: [Ingredient]
}

// MARK: - Ingredient
struct Ingredient: Codable {
    let food: String
}




