//
//  WebViewPresenterTests.swift
//  CompaniesSearchTests
//
//  Created by Vinicius Salmont on 11/01/21.
//

@testable import CompaniesSearch
import XCTest

class WebViewPresenterTests: XCTestCase {
    // MARK: - Subject under test
    var sut: WebViewPresenter!

    // MARK: - Test Lifecycle
    override func setUp() {
        super.setUp()
        setupPresenter()
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: - Test Setup
    func setupPresenter() {
        sut = WebViewPresenter()
    }

    // MARK: - Test Doubles
    class WebViewDisplayLogicSpy: WebViewDisplayLogic {
        var showWebViewCalled = false

        var viewModel: WebViewModels.GetURL.ViewModel!

        func showWebView(viewModel: WebViewModels.GetURL.ViewModel) {
            showWebViewCalled = true
            self.viewModel = viewModel
        }
    }

    // MARK: - Tests
    func testShouldFormatURL() {
        // Given
        let viewControllerSpy = WebViewDisplayLogicSpy()
        sut.viewController = viewControllerSpy

        // When
        let response = WebViewModels.GetURL.Response(url: Mocks.referenceModel.loginURL ?? "", name: Mocks.referenceModel.longName ?? "")
        sut.presentURL(response: response)

        // Then
        let viewModel = viewControllerSpy.viewModel

        XCTAssertEqual(viewModel?.displayedURL, Mocks.referenceModel.loginURL, "The presenter should properly format the url")
        XCTAssertEqual(viewModel?.name, Mocks.referenceModel.longName, "The presenter should properly format the longName")
    }
}
