//
//  SearchManager.swift
//  ReciPlease
//
//  Created by Adrien PEREA on 05/10/2021.
//

import Foundation
import Alamofire

class SearchService {

    var sessionManager: Session = {
           let configuration = URLSessionConfiguration.af.default
           configuration.timeoutIntervalForRequest = 30
           configuration.waitsForConnectivity = true
           return Session(configuration: configuration)
       }()


    func searchRecipe(ingredients: [String], mealType: String, dishType: String, callback: @escaping (Result<SearchResponse,AFError>) -> Void) {
        let ingredientsString = ingredients.joined(separator: ",")
        let mealFormatted = mealType == "All" ? "" : "&mealType=\(mealType)"
        let dishFormatted = dishType == "All" ? "" : "&dishType=\(dishType.replacingOccurrences(of: " ", with: "%20"))"
        guard let url = URL(string: "\(Constante.searchURL)\(ingredientsString)\(mealFormatted)\(dishFormatted)") else {return}
        let request = sessionManager.request(url)
        request.responseDecodable(of: SearchResponse.self) { response in
            callback(response.result)
        }
    }
    
    
    func loadNewPage(url: String, callback: @escaping (Result<SearchResponse,AFError>) -> Void) {
        guard let url = URL(string: url) else { return }
        let request = sessionManager.request(url)
        request.responseDecodable(of: SearchResponse.self) { response in
            callback(response.result)
        }
    }


}
