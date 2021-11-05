//
//  SearchManager.swift
//  ReciPlease
//
//  Created by Adrien PEREA on 05/10/2021.
//

import Foundation
import Alamofire

class SearchService {

    // MARK: Private Variable
    var sessionManager: Session = {
           let configuration = URLSessionConfiguration.af.default
           return Session(configuration: configuration)
       }()

    // MARK: Methods
    func searchRecipe(ingredients: [String], mealType: String, dishType: String, callback: @escaping (Result<SearchResponse,AFError>) -> Void) {
        let ingredientsString = ingredients.joined(separator: ",")
        let mealFormatted = mealType == "All" ? "" : "&mealType=\(mealType)"
        let dishFormatted = dishType == "All" ? "" : "&dishType=\(dishType.replacingOccurrences(of: " ", with: "%20"))"
        let urlString = "\(Constante.searchURL)\(ingredientsString)\(mealFormatted)\(dishFormatted)"
        guard let url = URL(string: urlString) else {
            callback(Result.failure(AFError.invalidURL(url: urlString)))
            return
        }
        let request = sessionManager.request(url)
        request.responseDecodable(of: SearchResponse.self) { response in
            guard response.response?.statusCode == 200 else {
                let status = response.response!.statusCode
                callback(Result.failure(AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: status))))
                return
            }
            callback(response.result)
        }
    }
    
    func loadNewPage(url: String, callback: @escaping (Result<SearchResponse,AFError>) -> Void) {
        guard let url = URL(string: url) else {
            callback(Result.failure(AFError.invalidURL(url: url)))
            return
        }
        let request = sessionManager.request(url)
        request.responseDecodable(of: SearchResponse.self) { response in
            guard response.response?.statusCode == 200 else {
                let status = response.response!.statusCode
                callback(Result.failure(AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: status))))
                return
            }
            callback(response.result)
        }
    }


}
