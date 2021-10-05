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
    let links: SearchLinks
    let hits: [Hit]

    enum CodingKeys: String, CodingKey {
        case count
        case links = "_links"
        case hits
    }
}

// MARK: - SearchLinks
struct SearchLinks: Codable {
    let next: Next
}

// MARK: - Next
struct Next: Codable {
    let href: String
}

enum Title: String, Codable {
    case nextPage = "Next page"
    case titleSelf = "Self"
}

// MARK: - Hit
struct Hit: Codable {
    let recipe: Recipe

    enum CodingKeys: String, CodingKey {
        case recipe
    }
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
}



