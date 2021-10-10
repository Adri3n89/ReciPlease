//
//  FavoriteRecipe.swift
//  ReciPlease
//
//  Created by Adrien PEREA on 09/10/2021.
//

import Foundation
import CoreData

class FavoriteRecipe: NSManagedObject {
    static var all: [FavoriteRecipe] {
        let request: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        guard let favoriteRecipes = try? AppDelegate.viewContext.fetch(request) else {
            return []
        }
        return favoriteRecipes
    }
}