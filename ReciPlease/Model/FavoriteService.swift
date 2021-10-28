//
//  FavoriteManager.swift
//  ReciPlease
//
//  Created by Adrien PEREA on 15/10/2021.
//

import Foundation
import Alamofire

class FavoriteService {
    
    // MARK: Private Variable
    private var sessionManager: Session = {
           let configuration = URLSessionConfiguration.af.default
           configuration.timeoutIntervalForRequest = 30
           configuration.waitsForConnectivity = false
           return Session(configuration: configuration)
       }()
    
    // MARK: Methods
    func loadFavorite(recipes: [FavoriteRecipe],callback: @escaping (Result<[Hit],AFError>) -> Void) {
        var allRecipes: [Hit] = []
        for recipe in recipes {
            guard let range = recipe.uri!.range(of: "#") else { return }
            let recipeURI = recipe.uri![range.upperBound...]
            guard let url = URL(string: Constante.favoriteURL(recipe: String(recipeURI))) else {
                callback(Result.failure(AFError.invalidURL(url: Constante.favoriteURL(recipe: String(recipeURI)))))
                return
            }
            let request = sessionManager.request(url)
            request.responseDecodable(of: Hit.self) { response in
                guard response.response?.statusCode == 200 else {
                    let status = response.response!.statusCode
                    callback(Result.failure(AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: status))))
                    return
                }
                guard let favorite = response.value, response.error == nil else {
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
