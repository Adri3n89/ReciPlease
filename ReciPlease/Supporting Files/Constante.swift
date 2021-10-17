//
//  Constante.swift
//  ReciPlease
//
//  Created by Adrien PEREA on 15/10/2021.
//

import Foundation

struct Constante {
    static let apiKey = "app_key=c64f200a51df3bf8200bf371740f5673"
    static let appID = "app_id=534c8951"
    static let searchURL = "https://api.edamam.com/api/recipes/v2?type=public&\(appID)&\(apiKey)&q="
    static func favoriteURL(recipe: String) -> String {
        "https://api.edamam.com/api/recipes/v2/\(recipe)?type=public&\(appID)&\(apiKey)"
    }
    static let error = "Error"
    static let ok = "OK"
    static let reciPlease = "Reciplease"
    static let search = "Search"
    static let searchIcon = "magnifyingglass"
    static let favorite = "Favorite"
    static let favoriteIcon = "star.fill"
    static let needOneIngredient = "please add at least 1 ingredient"
}
