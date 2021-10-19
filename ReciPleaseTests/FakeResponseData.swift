//
//  FakeResponseData.swift
//  ReciPleaseTests
//
//  Created by Adrien PEREA on 19/10/2021.
//

import Foundation

class FakeResponseData {

    var correctData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "datas", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }

    let incorrectData = "erreur".data(using: .utf8)!

}
