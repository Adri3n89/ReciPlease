//
//  FakeResponseData.swift
//  ReciPleaseTests
//
//  Created by Adrien PEREA on 19/10/2021.
//

import Foundation

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

}
