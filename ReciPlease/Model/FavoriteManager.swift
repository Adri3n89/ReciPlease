//
//  FavoriteManager.swift
//  ReciPlease
//
//  Created by Adrien PEREA on 15/10/2021.
//

import Foundation
import Alamofire

protocol FavoriteManagerDelegate {
    func loadFavoriteSuccess(recipes: [Hit])
    func loadFavoriteError(error: String)
}

class FavoriteManager {
    
    var delegate: FavoriteManagerDelegate
    
    init(delegate: FavoriteManagerDelegate) {
        self.delegate = delegate
    }
    
    func loadFavorite(recipes: [FavoriteRecipe]) {
        var allRecipes: [Hit] = []
        for recipe in recipes {
            guard let range = recipe.uri!.range(of: "#") else { return }
            let recipeURI = recipe.uri![range.upperBound...]
            let request = AF.request(Constante.favoriteURL(recipe: String(recipeURI)))
            request.responseDecodable(of: Hit.self) { response in
                guard let favorite = response.value else {
                    self.delegate.loadFavoriteError(error: response.error!.localizedDescription)
                    return
                }
                allRecipes.append(favorite)
                if allRecipes.count == recipes.count {
                    self.delegate.loadFavoriteSuccess(recipes: allRecipes)
                }
            }
        }
    }
}
