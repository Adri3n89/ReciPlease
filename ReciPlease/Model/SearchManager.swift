//
//  SearchManager.swift
//  ReciPlease
//
//  Created by Adrien PEREA on 05/10/2021.
//

import Foundation
import Alamofire

protocol searchManagerDelegate {
    func searchRecipeSuccess(response: SearchResponse)
    func searchRecipeError(error: String)
}

class SearchManager {
    
    var delegate: searchManagerDelegate
    
    init(delegate: searchManagerDelegate) {
        self.delegate = delegate
    }
    
    func searchRecipe(ingredients: [String]) {
        var ingredientsString = ""
        for ingredient in ingredients {
            ingredientsString += ingredient + ","
        }
        ingredientsString.removeLast()
        let appID = "app_id=534c8951"
        let appKey = "app_key=c64f200a51df3bf8200bf371740f5673"
        let request = AF.request("https://api.edamam.com/api/recipes/v2?type=public&q=\(ingredientsString)&\(appID)&\(appKey)")
        
        request.responseDecodable(of: SearchResponse.self) { response in
            guard let recipe = response.value else {
                self.delegate.searchRecipeError(error: response.error!.localizedDescription)
                return
            }
            self.delegate.searchRecipeSuccess(response: recipe)
            
        }
    }
    
    func loadNewPage(url: String) {
        let request = AF.request(url)
        request.responseDecodable(of: SearchResponse.self) { response in
            guard let recipe = response.value else { return }
            self.delegate.searchRecipeSuccess(response: recipe)
        }
    }
    
    
    
    
    
}
