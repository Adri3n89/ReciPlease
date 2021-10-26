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
    
    // MARK: Alamofire
    
    func testSearchRecipesWithBadData() {
        let searchService = SearchService()
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        let sessionManager = Alamofire.Session(configuration: configuration)
        let apiEndpoint = URL(string: "https://api.example.com/user")!
        let requestExpectation = expectation(description: "Request should finish")


        let mock = Mock(url: apiEndpoint, dataType: .json, statusCode: 200, data: [.get: FakeResponseData.incorrectData])
        mock.register()

        searchService.searchRecipe(session: sessionManager, ingredients: ["chicken"], mealType: "", dishType: "") { response in
            guard case .failure(let error) = response else { return }
            XCTAssertNotNil(error)
            requestExpectation.fulfill()
        }

        wait(for: [requestExpectation], timeout: 10.0)
    }
    
    func testSearchRecipesWithGoodData() {
        let searchService = SearchService()
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        let sessionManager = Alamofire.Session(configuration: configuration)
        let apiEndpoint = URL(string: "https://api.example.com/user")!
        let expectedResponse = FakeResponseData.correctData
        let mockedData = try! JSONDecoder().decode(SearchResponse.self, from: expectedResponse)
        let requestExpectation = expectation(description: "Request should finish")


        let mock = Mock(url: apiEndpoint, dataType: .json, statusCode: 200, data: [.get: expectedResponse])
        mock.register()

        searchService.searchRecipe(session: sessionManager, ingredients: ["chicken"], mealType: "", dishType: "") { response in
            guard case .success(let recipes) = response else { return }
            XCTAssertNotNil(recipes)
            requestExpectation.fulfill()
        }

        wait(for: [requestExpectation], timeout: 10.0)
    }


}
