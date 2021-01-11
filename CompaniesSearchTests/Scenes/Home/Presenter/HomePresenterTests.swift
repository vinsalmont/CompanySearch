//
//  HomePresenterTests.swift
//  CompaniesSearchTests
//
//  Created by Vinicius Salmont on 11/01/21.
//

@testable import CompaniesSearch
import XCTest

class HomePresenterTests: XCTestCase {
    // MARK: - Subject under test
    var sut: HomePresenter!

    // MARK: - Test Lifecycle
    override func setUp() {
        super.setUp()
        setupHomePresenter()
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: - Test Setup
    func setupHomePresenter() {
        sut = HomePresenter()
    }

    // MARK: - Test Doubles
    class HomeDisplayLogicSpy: HomeDisplayLogic {
        var showCompaniesCalled = false
        var showErrorCalled = false

        var viewModel: HomeModels.FetchCompanies.ViewModel!
        var errorMessage: String!

        func showCompanies(viewModel: HomeModels.FetchCompanies.ViewModel) {
            showCompaniesCalled = true
            self.viewModel = viewModel
        }

        func showError(message: String) {
            showErrorCalled = true
            errorMessage = message
        }
    }

    // MARK: - Tests
    func testShouldFormatCompanies() {
        // Given
        let viewControllerSpy = HomeDisplayLogicSpy()
        sut.viewController = viewControllerSpy

        // When
        let response = HomeModels.FetchCompanies.Response(items: Mocks.companiesResponsModel.results, nextUrl: Mocks.companiesResponsModel.next, previousUrl: Mocks.companiesResponsModel.previous)
        sut.presentCompanies(response: response)

        // Then
        let displayedCompanies = viewControllerSpy.viewModel.displayedCompanies
        for company in displayedCompanies {
            XCTAssertEqual(company.id, Mocks.referenceModel.id, "The presenter should properly format the id")
            XCTAssertEqual(company.name, Mocks.referenceModel.name, "The presenter should properly format the name")
            XCTAssertEqual(company.longName, Mocks.referenceModel.longName, "The presenter should properly format the longName")
            XCTAssertEqual(company.type, Mocks.referenceModel.type, "The presenter should properly format the type")
            XCTAssertEqual(company.category, Mocks.referenceModel.category, "The presenter should properly format the category")
            XCTAssertEqual(company.isDisabled, Mocks.referenceModel.isDisabled, "The presenter should properly format the isDisabled")
            XCTAssertEqual(company.loginURL, Mocks.referenceModel.loginURL, "The presenter should properly format the loginURL")
            XCTAssertEqual(company.logoURL, Mocks.referenceModel.completeLogoURL, "The presenter should properly format the completeLogoURL")
        }
    }

    func testShouldShowHomeCalled() {
        // Given
        let viewControllerSpy = HomeDisplayLogicSpy()
        sut.viewController = viewControllerSpy

        // When
        let response = HomeModels.FetchCompanies.Response(items: Mocks.companiesResponsModel.results, nextUrl: Mocks.companiesResponsModel.next, previousUrl: Mocks.companiesResponsModel.previous)
        sut.presentCompanies(response: response)

        // Then
        XCTAssert(viewControllerSpy.showCompaniesCalled, "The Presenter should have called the show companies scenario")
    }

    func testShouldPresentError() {
        // Given
        let viewControllerSpy = HomeDisplayLogicSpy()
        sut.viewController = viewControllerSpy

        // When
        let homeError = HomeModels.FetchCompanies.Error(message: "error")
        sut.presentError(error: homeError)

        // Then
        XCTAssert(viewControllerSpy.showErrorCalled, "The Presenter should have called the error scenario")
    }
}
