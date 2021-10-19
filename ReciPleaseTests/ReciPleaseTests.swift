//
//  ReciPleaseTests.swift
//  ReciPleaseTests
//
//  Created by Adrien PEREA on 04/10/2021.
//

import XCTest
import Alamofire
import Mocker
@testable import ReciPlease

class ReciPleaseTests: XCTestCase {
    
    func testFetchingRecipe() {
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self] + (configuration.protocolClasses ?? [])
        let sessionManager = Session(configuration: configuration)

        let apiEndpoint = URL(string: "https://api.url.com")!
        let requestExpectation = expectation(description: "Request should finish")

        let mockedData = FakeResponseData().correctData
        let mock = Mock(url: apiEndpoint, dataType: .json, statusCode: 200, data: [.get: mockedData])
        mock.register()
        
        let searchManager = SearchManager(delegate: SearchViewController())
        searchManager.sessionManager = sessionManager
        searchManager.searchRecipe(ingredients: ["chicken"], mealType: "", dishType: "")

        sessionManager
            .request(apiEndpoint)
            .responseDecodable(of: SearchResponse.self) { (response) in
                XCTAssertNil(response.error)
                XCTAssertNotNil(response.value)
                requestExpectation.fulfill()
            }.resume()

        wait(for: [requestExpectation], timeout: 10.0)
    }
    
    func testFetchingRecipeBadResponse() {
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self] + (configuration.protocolClasses ?? [])
        let sessionManager = Session(configuration: configuration)

        let apiEndpoint = URL(string: "https://api.url.com")!
        let requestExpectation = expectation(description: "Request should finish")

        let mockedData = FakeResponseData().incorrectData
        let mock = Mock(url: apiEndpoint, dataType: .json, statusCode: 500, data: [.get: mockedData])
        mock.register()
        
        let searchManager = SearchManager(delegate: SearchViewController())
        searchManager.sessionManager = sessionManager
        
        sessionManager
            .request(apiEndpoint)
            .responseDecodable(of: SearchResponse.self) { (response) in
                XCTAssertNotNil(response.error)
                XCTAssertNil(response.value)
                requestExpectation.fulfill()
            }.resume()
        
        searchManager.searchRecipe(ingredients: ["chicken"], mealType: "All", dishType: "All")


        wait(for: [requestExpectation], timeout: 10.0)
    }
    
    

}

