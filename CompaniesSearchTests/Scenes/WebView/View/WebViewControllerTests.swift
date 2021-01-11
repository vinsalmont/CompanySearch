//
//  WebViewControllerTests.swift
//  CompaniesSearchTests
//
//  Created by Vinicius Salmont on 11/01/21.
//

@testable import CompaniesSearch
import XCTest
import WebKit

class WebViewControllerTests: XCTestCase {

    // MARK: - Subject under test
    var sut: WebViewController!
    var window: UIWindow!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupViewController()
    }

    override func tearDown() {
        window = nil
        super.tearDown()
    }

    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }

    // MARK: - Setup
    func setupViewController() {
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        sut = storyboard.instantiateViewController(identifier: "WebViewController") as? WebViewController
    }

    // MARK: - Spys
    class WebViewBusinessLogicSpy: WebViewBusinessLogic {
        var url: String?
        var name: String?

        var getURLCalled = false

        func getURL() {
            getURLCalled = true
        }
    }

    // MARK: - Tests

    func testShouldDisplayCompanies() {
        // Given
        let webViewBusinessLogicSpy = WebViewBusinessLogicSpy()
        sut.interactor = webViewBusinessLogicSpy
        loadView()

        let viewModel = Mocks.displayedURL

        // When
        sut.showWebView(viewModel: viewModel)

        // Then
        XCTAssert(webViewBusinessLogicSpy.getURLCalled, "Should have called getURL")
        XCTAssertEqual(sut.navigationItem.title, viewModel.name)
    }

}
