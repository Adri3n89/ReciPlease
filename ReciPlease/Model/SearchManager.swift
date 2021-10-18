//
//  SearchManager.swift
//  ReciPlease
//
//  Created by Adrien PEREA on 05/10/2021.
//

import Foundation
import Alamofire

protocol SearchManagerDelegate {
    func searchRecipeSuccess(response: SearchResponse)
    func searchRecipeError(error: String)
}

class SearchManager {
    
    var delegate: SearchManagerDelegate
    
    init(delegate: SearchManagerDelegate) {
        self.delegate = delegate
    }
    
    func searchRecipe(ingredients: [String], mealType: String, dishType: String) {
        let ingredientsString = ingredients.joined(separator: ",")
        let mealFormatted = mealType == "All" ? "" : "&mealType=\(mealType)"
        let dishFormatted = dishType == "All" ? "" : "&dishType=\(dishType.replacingOccurrences(of: " ", with: "%20"))"
        let request = AF.request("\(Constante.searchURL)\(ingredientsString)\(mealFormatted)\(dishFormatted)")
        
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
