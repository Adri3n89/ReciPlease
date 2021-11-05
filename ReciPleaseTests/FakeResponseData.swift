//
//  FakeResponseData.swift
//  ReciPleaseTests
//
//  Created by Adrien PEREA on 19/10/2021.
//

import Foundation
@testable import ReciPlease

class FakeResponseData {

    static let incorrectData = "erreur".data(using: .utf8)!
    static var correctData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "datas", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    static let favorite1Uri = "http://www.edamam.com/ontologies/edamam.owl#recipe_485d47f3feeff11b30a26667bb104722"
    static let favorite1Url = URL(string: "https://api.edamam.com/api/recipes/v2/recipe_485d47f3feeff11b30a26667bb104722?type=public&app_id=534c8951&app_key=c64f200a51df3bf8200bf371740f5673")!
    static let favorite2Uri = "http://www.edamam.com/ontologies/edamam.owl#recipe_00999988c3d37cad1ae7dc2d98f6d345"
    static let favorite2Url = URL(string: "https://api.edamam.com/api/recipes/v2/recipe_00999988c3d37cad1ae7dc2d98f6d345?type=public&app_id=534c8951&app_key=c64f200a51df3bf8200bf371740f5673")!
    static let newPageUrlString = "https://api.edamam.com/api/recipes/v2?q=chicken%2Clemon&app_key=c64f200a51df3bf8200bf371740f5673&_cont=CHcVQBtNNQphDmgVQntAEX4BYVdtDQAERGBGC2sValJxAgYAUXlSVWAUZ1BzUlFUFWNAVWQaZV0mUABUS2UUBWQSNgYiVgIVLnlSVSBMPkd5BgMbUSYRVTdgMgksRlpSAAcRXTVGcV84SU4%3D&type=public&app_id=534c8951"
    static let newPageBadUrlString = "Bad Url"
    
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
