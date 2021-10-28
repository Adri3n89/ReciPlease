//
//  FakeResponseData.swift
//  ReciPleaseTests
//
//  Created by Adrien PEREA on 19/10/2021.
//

import Foundation
@testable import ReciPlease

class FakeResponseData {

    static let reponseOK = HTTPURLResponse(url: URL(string: "http://validateproject10.fr")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    static let reponseKO = HTTPURLResponse(url: URL(string: "http://validateproject10.fr")!, statusCode: 500, httpVersion: nil, headerFields: nil)!

    class SearchError: Error {}
    static let error = SearchError()

    static let incorrectData = "erreur".data(using: .utf8)!
    static var correctData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "datas", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    static let favorite1 = "http://www.edamam.com/ontologies/edamam.owl#recipe_485d47f3feeff11b30a26667bb104722"
    static let favorite2 = "http://www.edamam.com/ontologies/edamam.owl#recipe_00999988c3d37cad1ae7dc2d98f6d345"

    static var correctFavoriteData1: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "favorite1", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    static var correctFavoriteData2: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "favorite2", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
}
