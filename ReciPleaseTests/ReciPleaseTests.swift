//
//  ReciPleaseTests.swift
//  ReciPleaseTests
//
//  Created by Adrien PEREA on 04/10/2021.
//

import XCTest
import Alamofire
import CoreData
import Mocker

@testable import ReciPlease

final class ReciPleaseTests: XCTestCase {
    
    // MARK: Test CoreData
    
    override class func setUp() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FavoriteRecipe")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        let context = CoreDataStack().persistentContainer.newBackgroundContext()
        do {
           try! context.execute(deleteRequest)
        }
    }
    
    func testAddTwoRecipe() {
        //Given
        let context = CoreDataStack().persistentContainer.newBackgroundContext()
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context) { _ in
            return true
        }
        FavoriteRecipe.addRecipe(uri: "recette1", context: context)
        FavoriteRecipe.addRecipe(uri: "recette2", context: context)
        let favorites = FavoriteRecipe.getAll(context: context)
        waitForExpectations(timeout: 10.0) { error in
            XCTAssertEqual(2, favorites.count)
        }
    }
    
    func testAddTwoAndDeleteOneRecipe() {
        //Given
        let context = CoreDataStack().persistentContainer.newBackgroundContext()
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context) { _ in
            return true
        }
        FavoriteRecipe.addRecipe(uri: "recette1", context: context)
        FavoriteRecipe.addRecipe(uri: "recette2", context: context)
        FavoriteRecipe.deleteRecipe(uri: "recette1", context: context)
        let favorites = FavoriteRecipe.getAll(context: context)
        waitForExpectations(timeout: 10.0) { error in
            XCTAssertEqual(1, favorites.count)
        }
    }
    
    // MARK: SearchService - SearchRecipe
    
    // MARK: BAD DATA
    func testSearchRecipesWithBadData() {
        let searchService = SearchService()
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        let sessionManager = Alamofire.Session(configuration: configuration)
        searchService.sessionManager = sessionManager
        let apiEndpoint = URL(string: "\(Constante.searchURL)chicken")!
        let requestExpectation = expectation(description: "Request should finish")

        let mock = Mock(url: apiEndpoint, dataType: .json, statusCode: 200, data: [.get: FakeResponseData.incorrectData])
        mock.register()

        searchService.searchRecipe(ingredients: ["chicken"], mealType: "All", dishType: "All") { response in
            if case .failure(let error) = response {
                XCTAssertNotNil(error)
                requestExpectation.fulfill()
            }
        }
        wait(for: [requestExpectation], timeout: 10.0)
    }
    
    // MARK: BAD RESPONSE
    func testSearchRecipesWithBadResponse() {
        let searchService = SearchService()
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        let sessionManager = Alamofire.Session(configuration: configuration)
        searchService.sessionManager = sessionManager
        let apiEndpoint = URL(string: "\(Constante.searchURL)chicken")!
        let requestExpectation = expectation(description: "Request should finish")

        let mock = Mock(url: apiEndpoint, dataType: .json, statusCode: 500, data: [.get: Data()])
        mock.register()

        searchService.searchRecipe(ingredients: ["chicken"], mealType: "All", dishType: "All") { response in
            if case .failure(let error) = response {
                XCTAssertNotNil(error)
                XCTAssertEqual(error.localizedDescription, AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 500)).localizedDescription)
                requestExpectation.fulfill()
            }
        }
        wait(for: [requestExpectation], timeout: 10.0)
    }
    
    // MARK: BAD URL
    func testSearchRecipesWithBadURL() {
        let searchService = SearchService()
        let apiEndpoint = "\(Constante.searchURL)chicken and cheese&mealType=Breakfast&dishType=Bread"
        let requestExpectation = expectation(description: "Request should finish")
        searchService.searchRecipe(ingredients: ["chicken and cheese"], mealType: "Breakfast", dishType: "Bread") { response in
            if case .failure(let error) = response {
                XCTAssertNotNil(error)
                XCTAssertEqual(error.localizedDescription, AFError.invalidURL(url: apiEndpoint).localizedDescription)
                requestExpectation.fulfill()
            }
        }
        wait(for: [requestExpectation], timeout: 10.0)
    }
    
    // MARK: GOOD DATA
    func testSearchRecipesWithGoodData() {
        let searchService = SearchService()
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        let sessionManager = Alamofire.Session(configuration: configuration)
        searchService.sessionManager = sessionManager
        let apiEndpoint = URL(string: "\(Constante.searchURL)chicken&mealType=Breakfast&dishType=Bread")!
        let expectedResponse = FakeResponseData.correctData
        let mockedData = try! JSONDecoder().decode(SearchResponse.self, from: expectedResponse)
        let requestExpectation = expectation(description: "Request should finish")

        let mock = Mock(url: apiEndpoint, dataType: .json, statusCode: 200, data: [.get: expectedResponse])
        mock.register()

        searchService.searchRecipe(ingredients: ["chicken"], mealType: "Breakfast", dishType: "Bread") { response in
            if case .success(let recipes) = response {
                XCTAssertNotNil(recipes)
                XCTAssertEqual(recipes, mockedData)
                requestExpectation.fulfill()
            }
        }
        wait(for: [requestExpectation], timeout: 10.0)
    }
    
    // MARK: SearchService - LoadNewPage
    
    // MARK: BAD DATA
    func testLoadNewPageWithBadData() {
        let searchService = SearchService()
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        let sessionManager = Alamofire.Session(configuration: configuration)
        searchService.sessionManager = sessionManager
        let apiEndpoint = URL(string: FakeResponseData.newPageUrlString)!
        let expectedResponse = FakeResponseData.incorrectData
        let requestExpectation = expectation(description: "Request should finish")

        let mock = Mock(url: apiEndpoint, dataType: .json, statusCode: 200, data: [.get: expectedResponse])
        mock.register()
        
        searchService.loadNewPage(url: FakeResponseData.newPageUrlString) { response in
            if case .failure(let error) = response {
                XCTAssertNotNil(error)
                requestExpectation.fulfill()
            }
        }
        wait(for: [requestExpectation], timeout: 10.0)
    }
    
    // MARK: BAD RESPONSE
    func testLoadNewPageWithBadResponse() {
        let searchService = SearchService()
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        let sessionManager = Alamofire.Session(configuration: configuration)
        searchService.sessionManager = sessionManager
        let apiEndpoint = URL(string: FakeResponseData.newPageUrlString)!
        let requestExpectation = expectation(description: "Request should finish")

        let mock = Mock(url: apiEndpoint, dataType: .json, statusCode: 500, data: [.get: Data()])
        mock.register()
        
        searchService.loadNewPage(url: FakeResponseData.newPageUrlString) { response in
            if case .failure(let error) = response {
                XCTAssertNotNil(error)
                XCTAssertEqual(error.localizedDescription, AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 500)).localizedDescription)
                requestExpectation.fulfill()
            }
        }
        wait(for: [requestExpectation], timeout: 10.0)
    }
    
    // MARK: BAD URL
    func testLoadNewPageWithBadURL() {
        let searchService = SearchService()
        let apiEndpoint = FakeResponseData.newPageBadUrlString
        let requestExpectation = expectation(description: "Request should finish")
        
        searchService.loadNewPage(url: apiEndpoint) { response in
            if case .failure(let error) = response {
                XCTAssertNotNil(error)
                XCTAssertEqual(error.localizedDescription, AFError.invalidURL(url: apiEndpoint).localizedDescription)
                requestExpectation.fulfill()
            }
        }
        wait(for: [requestExpectation], timeout: 10.0)
    }
    
    // MARK: GOOD DATA
    func testLoadNewPageWithGoodData() {
        let searchService = SearchService()
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        let sessionManager = Alamofire.Session(configuration: configuration)
        searchService.sessionManager = sessionManager
        let apiEndpoint = URL(string: FakeResponseData.newPageUrlString)!
        let expectedResponse = FakeResponseData.correctData
        let mockedData = try! JSONDecoder().decode(SearchResponse.self, from: expectedResponse)
        let requestExpectation = expectation(description: "Request should finish")

        let mock = Mock(url: apiEndpoint, dataType: .json, statusCode: 200, data: [.get: expectedResponse])
        mock.register()
        
        searchService.loadNewPage(url: FakeResponseData.newPageUrlString) { response in
            if case .success(let recipes) = response {
                XCTAssertNotNil(recipes)
                XCTAssertEqual(recipes, mockedData)
                requestExpectation.fulfill()
            }
        }
        wait(for: [requestExpectation], timeout: 10.0)
    }
    
    // MARK: FavoriteService - LoadFavorite
    
    // MARK: BAD DATA
    func testLoadFavoriteWithBadData() {
        let context = CoreDataStack().persistentContainer.newBackgroundContext()
        let favoriteService = FavoriteService()
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        let sessionManager = Alamofire.Session(configuration: configuration)
        favoriteService.sessionManager = sessionManager

        let expectedResponse = FakeResponseData.incorrectData
        let requestExpectation = expectation(description: "Request should finish")

        let favorite1 = FavoriteRecipe(context: context)
        favorite1.uri = FakeResponseData.favorite1Uri

        let mock = Mock(url: FakeResponseData.favorite1Url, dataType: .json, statusCode: 200, data: [.get: expectedResponse])
        mock.register()

        favoriteService.loadFavorite(recipes: [favorite1]) { response in
            if case .failure(let error) = response {
                XCTAssertNotNil(error)
                requestExpectation.fulfill()
            }
        }
        wait(for: [requestExpectation], timeout: 10.0)
    }
    
    // MARK: BAD RESPONSE
    func testLoadFavoriteWithBadResponse() {
        let context = CoreDataStack().persistentContainer.newBackgroundContext()
        let favoriteService = FavoriteService()
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        let sessionManager = Alamofire.Session(configuration: configuration)
        favoriteService.sessionManager = sessionManager
        let requestExpectation = expectation(description: "Request should finish")

        let favorite1 = FavoriteRecipe(context: context)
        favorite1.uri = FakeResponseData.favorite1Uri
       
        let mock = Mock(url: FakeResponseData.favorite1Url, dataType: .json, statusCode: 500, data: [.get: Data()])
        mock.register()
        
        favoriteService.loadFavorite(recipes: [favorite1]) { response in
            if case .failure(let error) = response {
                XCTAssertNotNil(error)
                XCTAssertEqual(error.localizedDescription, AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 500)).localizedDescription)
                requestExpectation.fulfill()
            }
        }
        wait(for: [requestExpectation], timeout: 10.0)
    }

    // MARK: BAD URL
    func testLoadFavoriteWithBadURL() {
        let context = CoreDataStack().persistentContainer.newBackgroundContext()
        let favoriteService = FavoriteService()
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        let sessionManager = Alamofire.Session(configuration: configuration)
        favoriteService.sessionManager = sessionManager
        let requestExpectation = expectation(description: "Request should finish")

        let favorite1 = FavoriteRecipe(context: context)
        favorite1.uri = "#bad URL"
        
        let badURL = "https://api.edamam.com/api/recipes/v2/bad URL?type=public&app_id=534c8951&app_key=c64f200a51df3bf8200bf371740f5673"
        favoriteService.loadFavorite(recipes: [favorite1]) { response in
            if case .failure(let error) = response {
                XCTAssertNotNil(error)
                XCTAssertEqual(error.localizedDescription, AFError.invalidURL(url: badURL).localizedDescription)
                requestExpectation.fulfill()
            }
        }
        wait(for: [requestExpectation], timeout: 10.0)
    }

    // MARK: GOOD DATA
    func testLoadFavoriteWithGoodData() {
        let context = CoreDataStack().persistentContainer.newBackgroundContext()
        let favoriteService = FavoriteService()
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        let sessionManager = Alamofire.Session(configuration: configuration)
        favoriteService.sessionManager = sessionManager

        let expectedResponse1 = FakeResponseData.correctFavoriteData1
        let mockedData1 = try! JSONDecoder().decode(Hit.self, from: expectedResponse1)
        let expectedResponse2 = FakeResponseData.correctFavoriteData2
        let mockedData2 = try! JSONDecoder().decode(Hit.self, from: expectedResponse2)

        let requestExpectation = expectation(description: "Request should finish")

        let mock1 = Mock(url: FakeResponseData.favorite1Url, dataType: .json, statusCode: 200, data: [.get: expectedResponse1])
        mock1.register()

        let mock2 = Mock(url: FakeResponseData.favorite2Url, dataType: .json, statusCode: 200, data: [.get: expectedResponse2])
        mock2.register()

        let favorite1 = FavoriteRecipe(context: context)
        favorite1.uri = FakeResponseData.favorite1Uri
        let favorite2 = FavoriteRecipe(context: context)
        favorite2.uri = FakeResponseData.favorite2Uri

        favoriteService.loadFavorite(recipes: [favorite1, favorite2]) { response in
            if case .success(let recipes) = response {
                XCTAssertNotNil(recipes)
                XCTAssertEqual(recipes, [mockedData1, mockedData2])
                requestExpectation.fulfill()
            }
        }
        wait(for: [requestExpectation], timeout: 10.0)
    }

}
