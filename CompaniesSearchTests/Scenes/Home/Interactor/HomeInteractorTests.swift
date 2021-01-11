//
//  HomeInteractorTests.swift
//  CompaniesSearchTests
//
//  Created by Vinicius Salmont on 11/01/21.
//

@testable import CompaniesSearch
import XCTest

class HomeInteractorTests: XCTestCase {

    // MARK: - Subject under test
    var sut: HomeInteractor!

    // MARK: - Test Lifecycle
    override func setUp() {
        super.setUp()
        setupInteractor()
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: - Test Setup
    func setupInteractor() {
        sut = HomeInteractor()
    }

    // MARK: - Test doubles
    class HomePresentationLogicSpy: HomePresentationLogic {
        var presentErrorCalled = false
        var presentCompaniesCalled = false

        func presentError(error: HomeModels.FetchCompanies.Error) {
            presentErrorCalled = true
        }

        func presentCompanies(response: HomeModels.FetchCompanies.Response) {
            presentCompaniesCalled = true
        }
    }

    class HomeSuccessWorkerSpy: HomeWorker {
        var searchCompaniesCalled = false
        var paginateCompaniesCalled = false

        override func searchCompanies(query: String, success: @escaping ((CompaniesResponse) -> Void), failure: @escaping ((String) -> Void)) {
            searchCompaniesCalled = true

            success(Mocks.companiesResponsModel)
        }

        override func paginateCompanies(url: String, success: @escaping ((CompaniesResponse) -> Void), failure: @escaping ((String) -> Void)) {
            paginateCompaniesCalled = true

            success(Mocks.companiesResponsModel)
        }
    }

    class HomeFailureWorkerSpy: HomeWorker {
        var searchCompaniesCalled = false
        var paginateCompaniesCalled = false

        override func searchCompanies(query: String, success: @escaping ((CompaniesResponse) -> Void), failure: @escaping ((String) -> Void)) {
            searchCompaniesCalled = true

            failure("Error")
        }

        override func paginateCompanies(url: String, success: @escaping ((CompaniesResponse) -> Void), failure: @escaping ((String) -> Void)) {
            paginateCompaniesCalled = true

            failure("Error")
        }
    }

    // MARK: - Tests
    func testShouldSearchFromWorker() {
        // Given
        let presenterSpy = HomePresentationLogicSpy()
        sut.presenter = presenterSpy
        let workerSpy = HomeSuccessWorkerSpy()
        sut.worker = workerSpy

        // When
        let request = HomeModels.FetchCompanies.Search(query: "")
        sut.searchCompanies(request: request)

        // Then
        XCTAssert(workerSpy.searchCompaniesCalled, "Should've asked Worker to search the companies")
        XCTAssert(presenterSpy.presentCompaniesCalled, "Should've asked the presenter to format the results")
        XCTAssertFalse(presenterSpy.presentErrorCalled, "Shouldn't have presented the error")
    }

    func testShouldNotSearchFromWorker() {
        // Given
        let presenterSpy = HomePresentationLogicSpy()
        sut.presenter = presenterSpy
        let workerSpy = HomeFailureWorkerSpy()
        sut.worker = workerSpy

        // When
        let request = HomeModels.FetchCompanies.Search(query: "")
        sut.searchCompanies(request: request)

        // Then
        XCTAssert(workerSpy.searchCompaniesCalled, "Should've asked Worker to search the companies")
        XCTAssertFalse(presenterSpy.presentCompaniesCalled, "Shouldn't have asked the presenter to format the results")
        XCTAssert(presenterSpy.presentErrorCalled, "Should've presented the error")
    }

    func testShouldPaginateFromWorker() {
        // Given
        let presenterSpy = HomePresentationLogicSpy()
        sut.presenter = presenterSpy
        let workerSpy = HomeSuccessWorkerSpy()
        sut.worker = workerSpy

        // When
        let request = HomeModels.FetchCompanies.Paginate(url: "")
        sut.paginateCompanies(request: request)

        // Then
        XCTAssert(workerSpy.paginateCompaniesCalled, "Should've asked Worker to search the companies")
        XCTAssert(presenterSpy.presentCompaniesCalled, "Should've asked the presenter to format the results")
        XCTAssertFalse(presenterSpy.presentErrorCalled, "Shouldn't have presented the error")
    }

    func testShouldNotPaginateFromWorker() {
        // Given
        let presenterSpy = HomePresentationLogicSpy()
        sut.presenter = presenterSpy
        let workerSpy = HomeFailureWorkerSpy()
        sut.worker = workerSpy

        // When
        let request = HomeModels.FetchCompanies.Paginate(url: "")
        sut.paginateCompanies(request: request)

        // Then
        XCTAssert(workerSpy.paginateCompaniesCalled, "Should've asked Worker to search the companies")
        XCTAssertFalse(presenterSpy.presentCompaniesCalled, "Shouldn't have asked the presenter to format the results")
        XCTAssert(presenterSpy.presentErrorCalled, "Should've presented the error")
    }

}
