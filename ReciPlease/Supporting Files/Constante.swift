//
//  Constante.swift
//  ReciPlease
//
//  Created by Adrien PEREA on 15/10/2021.
//

import Foundation
import UIKit

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
    static let noFavoriteString = "Oups!\nIt looks like you don't have favorite recipe yet.\nDo a search, select a recipe and click on the favorites button to find the recipe on this tab"
    static let noRecipeString = "Oups!\nIt looks like we don't find any recipe for you.\nPlease change your ingredient or add more"
    static let noFavoriteImage = "book"
    static let noRecipeImage = "cloche"
    static let defaultImage = "default"
    static let greenColor = UIColor(red: 82/255, green: 181/255, blue: 176/255, alpha: 1)
    static let blueColor = UIColor(red: 199/255, green: 229/255, blue: 233/255, alpha: 1)
    static let dishType = [
        "All",
        "Biscuits and cookies",
        "Bread",
        "Cereals",
        "Condiments and sauces",
        "Desserts",
        "Drinks",
        "Main course",
        "Pancake",
        "Preps",
        "Preserve",
        "Salad",
        "Sandwishes",
        "Side dish",
        "Soup",
        "Starter",
        "Sweets"
    ]
    static let mealType = [
        "All",
        "Breakfast",
        "Dinner",
        "Lunch",
        "Snack",
        "Teatime"
    ]
}
