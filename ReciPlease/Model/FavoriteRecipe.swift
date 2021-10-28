//
//  FavoriteRecipe.swift
//  ReciPlease
//
//  Created by Adrien PEREA on 09/10/2021.
//

import Foundation
import CoreData

class FavoriteRecipe: NSManagedObject {
    
    static func getAll(context: NSManagedObjectContext) -> [FavoriteRecipe] {
        let request: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        let favoriteRecipes = try! context.fetch(request)
        return favoriteRecipes
    }
    
    static func deleteRecipe(uri: String, context: NSManagedObjectContext) {
        for recipe in FavoriteRecipe.getAll(context: context) {
            if recipe.uri == uri {
                context.delete(recipe)
            }
        }
        try? context.save()
    }
    
    static func addRecipe(uri: String, context: NSManagedObjectContext) {
        let favorite = FavoriteRecipe(context: context)
        favorite.uri = uri
        try? context.save()
    }
    
}
