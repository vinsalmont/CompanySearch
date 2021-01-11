//
//  WebViewInteractorTests.swift
//  CompaniesSearchTests
//
//  Created by Vinicius Salmont on 11/01/21.
//

@testable import CompaniesSearch
import XCTest

class WebViewInteractorTests: XCTestCase {

    // MARK: - Subject under test
    var sut: WebViewInteractor!

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
        sut = WebViewInteractor()
    }

    // MARK: - Test doubles
    class WebViewPresentationLogicSpy: WebViewPresentationLogic {
        var presentURLCalled = false

        func presentURL(response: WebViewModels.GetURL.Response) {
            presentURLCalled = true
        }
    }

    // MARK: - Tests
    func testShouldPresentURL() {
        // Given
        let presenterSpy = WebViewPresentationLogicSpy()
        sut.presenter = presenterSpy
        sut.url = Mocks.referenceModel.loginURL
        sut.name = Mocks.referenceModel.longName

        // When
        sut.getURL()

        // Then
        XCTAssert(presenterSpy.presentURLCalled, "Should've asked the presenter to show url")
    }

}
