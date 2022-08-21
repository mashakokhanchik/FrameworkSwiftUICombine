//
//  Rick_MortyCombineTests.swift
//  Rick&MortyCombineTests
//
//  Created by Мария Коханчик on 12.08.2022.
//

import XCTest
import Combine
@testable import Rick_MortyCombine

class Rick_MortyCombineTests: XCTestCase {
    
    var viewModel: CharactersViewModel!
    let apiClient = APIClient()
    var subscriptions = Set<AnyCancellable>()

    override func setUpWithError() throws {
        viewModel = CharactersViewModel()
    }

    override func tearDownWithError() throws {
        subscriptions = []
    }

    func testFilterText() throws {
        /// Given
        let expected = "Filter: alive, female"
        var result = ""
        
        viewModel.$filterTags
            .sink(receiveValue: { [weak self] _ in
                result = self?.viewModel.filterText ?? ""})
            .store(in: &subscriptions)
        /// When
        viewModel.filterTags = [.alive, .female]
        viewModel.filterTags = []
        /// Then
        XCTAssert(
            result == expected,
            "Wrong header text. Expected: \(expected), result: \(result)"
        )
    }

}
