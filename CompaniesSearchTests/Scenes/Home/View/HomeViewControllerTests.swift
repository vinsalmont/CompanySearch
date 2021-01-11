//
//  HomeViewControllerTests.swift
//  CompaniesSearchTests
//
//  Created by Vinicius Salmont on 11/01/21.
//

@testable import CompaniesSearch
import XCTest

class HomeViewControllerTests: XCTestCase {

    // MARK: - Subject under test
    var sut: HomeViewController!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        setupHomeViewController()
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: - Setup
    func setupHomeViewController() {
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        sut = storyboard.instantiateViewController(identifier: "HomeViewController") as? HomeViewController
        _ = sut.view
    }

    // MARK: - Spys
    class HomeBusinessLogicSpy: HomeBusinessLogic {
        var companies: [Company]?

        var searchCompanyCalled = false
        var paginatCalled = false


        func searchCompanies(request: HomeModels.FetchCompanies.Search) {
            searchCompanyCalled = true
        }

        func paginateCompanies(request: HomeModels.FetchCompanies.Paginate) {
            paginatCalled = true
        }
    }

    class TableViewSpy: UITableView {
        var reloadDataCalled = false

        override func reloadData() {
            reloadDataCalled = true
        }
    }

    // MARK: - Tests

    func testShouldDisplayCompanies() {
        // Given
        let tableViewSpy = TableViewSpy()
        sut.tableView = tableViewSpy
        _ = sut.view

        let displayedCompanies = [Mocks.displayedCompany]
        let viewModel = HomeModels.FetchCompanies.ViewModel(displayedCompanies: displayedCompanies, nextUrl: Mocks.companiesResponsModel.next, previousUrl: Mocks.companiesResponsModel.previous)

        // When
        sut.showCompanies(viewModel: viewModel)

        // Then
        XCTAssert(tableViewSpy.reloadDataCalled, "should have called reload data")
    }

    func testShouldFetchCompaniesByQuery() {
        // Given
        let homeBusinessLogicSpy = HomeBusinessLogicSpy()
        sut.interactor = homeBusinessLogicSpy
        _ = sut.view

        // When
        sut.navigationItem.searchController?.searchBar.text = "uber"
        sut.searchBar(sut.navigationItem.searchController!.searchBar, textDidChange: "uber")

        // Then
        let exp = expectation(description: "Test after 1 seconds")
        let result = XCTWaiter.wait(for: [exp], timeout: 1)
        if result == XCTWaiter.Result.timedOut {
            XCTAssert(homeBusinessLogicSpy.searchCompanyCalled, "It should search the companies")
        } else {
            XCTFail("Delay interrupted")
        }
    }

    func testShouldPaginateCompanies() {
        // Given
        let homeBusinessLogicSpy = HomeBusinessLogicSpy()
        sut.interactor = homeBusinessLogicSpy
        _ = sut.view

        let displayedCompanies = [Mocks.displayedCompany]
        let viewModel = HomeModels.FetchCompanies.ViewModel(displayedCompanies: displayedCompanies, nextUrl: Mocks.companiesResponsModel.next, previousUrl: Mocks.companiesResponsModel.previous)

        // When
        sut.showCompanies(viewModel: viewModel)
        sut.nextButton.isEnabled = true
        sut.nextButton.sendActions(for: .touchUpInside)

        // Then
        XCTAssert(homeBusinessLogicSpy.paginatCalled, "It should paginate")
    }

    func testShouldPopulateTheTableViewCorrectly() {
        // Given
        let tableView = sut.tableView

        let displayedCompanies = [Mocks.displayedCompany]
        let viewModel = HomeModels.FetchCompanies.ViewModel(displayedCompanies: displayedCompanies, nextUrl: Mocks.companiesResponsModel.next, previousUrl: Mocks.companiesResponsModel.previous)

        // When
        sut.showCompanies(viewModel: viewModel)
        let numberOfRows = sut.tableView(tableView!, numberOfRowsInSection: 0)

        // Then
        XCTAssertEqual(numberOfRows, displayedCompanies.count, "The number of items on the Table View should match the companies array")
    }

    func testShouldConfigureTableViewCells() {
        // Given
        let tableView = sut.tableView
        let displayedCompanies = [Mocks.displayedCompany]
        let viewModel = HomeModels.FetchCompanies.ViewModel(displayedCompanies: displayedCompanies, nextUrl: Mocks.companiesResponsModel.next, previousUrl: Mocks.companiesResponsModel.previous)

        // When
        sut.showCompanies(viewModel: viewModel)
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.tableView(tableView!, cellForRowAt: indexPath) as! CompanyTableViewCell

        //Then
        XCTAssertEqual(cell.companyNameLabel.text, "Uber")
        XCTAssertEqual(cell.companyDescriptionLabel.text, "company")
    }
}
