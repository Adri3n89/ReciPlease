//
//  APIResponse.swift
//  ReciPlease
//
//  Created by Adrien PEREA on 05/10/2021.
//

import Foundation

// MARK: - APIResponse
struct SearchResponse: Codable {
    let from, to, count: Int
    var links: SearchLinks
    var hits: [Hit]

    enum CodingKeys: String, CodingKey {
        case from, to, count
        case links = "_links"
        case hits
    }
}

// MARK: - Hit
struct Hit: Codable {
    let recipe: Recipe
    var links: HitLinks

    enum CodingKeys: String, CodingKey {
        case recipe
        case links = "_links"
    }
}

// MARK: - HitLinks
struct HitLinks: Codable {
    let linksSelf: Next

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
    }
}

// MARK: - Next
struct Next: Codable {
    var href: String
    let title: Title
}

enum Title: String, Codable {
    case nextPage = "Next page"
    case titleSelf = "Self"
    case title = "title"
}

// MARK: - Recipe
struct Recipe: Codable {
    let uri: String
    let label: String
    let image: String
    let source: String
    let url: String
    let shareAs: String
    let yield: Float
    let cuisineType, mealType, dishType: [String]
    let ingredientLines: [String]
    let ingredients: [Ingredient]
    let totalTime: Int
}

// MARK: - Ingredient
struct Ingredient: Codable {
    let food: String
    enum CodingKeys: String, CodingKey {
        case food
    }
}

// MARK: - SearchLinks
struct SearchLinks: Codable {
    var next: Next?
}
