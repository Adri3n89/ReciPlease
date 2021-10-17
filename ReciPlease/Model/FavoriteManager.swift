//
//  FavoriteManager.swift
//  ReciPlease
//
//  Created by Adrien PEREA on 15/10/2021.
//

import Foundation
import Alamofire

protocol FavoriteManagerDelegate {
    func loadFavoriteSuccess(recipe: Hit)
    func loadFavoriteError(error: String)
}

class FavoriteManager {
    
    var delegate: FavoriteManagerDelegate
    
    init(delegate: FavoriteManagerDelegate) {
        self.delegate = delegate
    }
    
    func loadFavorite(recipe: String) {
        guard let range = recipe.range(of: "#") else { return }
        let recipeURI = recipe[range.upperBound...]
        let request = AF.request(Constante.favoriteURL(recipe: String(recipeURI)))
        request.responseDecodable(of: Hit.self) { response in
            guard let favorite = response.value else {
                self.delegate.loadFavoriteError(error: response.error!.localizedDescription)
                return
            }
            self.delegate.loadFavoriteSuccess(recipe: favorite)
        }
    }
}
