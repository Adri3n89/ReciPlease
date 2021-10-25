//
//  FavoriteManager.swift
//  ReciPlease
//
//  Created by Adrien PEREA on 15/10/2021.
//

import Foundation
import Alamofire

class FavoriteService {
    
    func loadFavorite(recipes: [FavoriteRecipe],callback: @escaping (Result<[Hit],AFError>) -> Void) {
        var allRecipes: [Hit] = []
        for recipe in recipes {
            guard let range = recipe.uri!.range(of: "#") else { return }
            let recipeURI = recipe.uri![range.upperBound...]
            let request = AF.request(Constante.favoriteURL(recipe: String(recipeURI)))
            request.responseDecodable(of: Hit.self) { response in
                guard let favorite = response.value, response.error == nil, response.response?.statusCode == 200 else {
                    callback(.failure(response.error!))
                    return
                }
                allRecipes.append(favorite)
                if allRecipes.count == recipes.count {
                callback(.success(allRecipes))
                }
            }
        }
    }
}
