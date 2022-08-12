//
//  SlotMachineCombineTests.swift
//  SlotMachineCombineTests
//
//  Created by Мария Коханчик on 11.08.2022.
//

import XCTest
import Combine
@testable import SlotMachineCombine

class SlotMachineCombineTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    var viewModel: SlotMachineModel!

    override func setUpWithError() throws {
        viewModel = SlotMachineModel()
    }

    override func tearDownWithError() throws {
        cancellables = []
    }

    func testButtonTextChanged() {
        let expected = "Play"
        let expectation = XCTestExpectation()
        
        viewModel
            .$textButton
            .dropFirst()
            .sink { value in XCTAssertEqual(value, expected); expectation.fulfill() }
            .store(in: &cancellables)
        
        viewModel.running = false
        
        wait(for: [expectation], timeout: 1)
    }

    func testWon() {
        let expected = "You won!!!"
        let expectation = XCTestExpectation()
        
        viewModel
            .$textTitle
            .dropFirst()
            .sink { value in XCTAssertEqual(value, expected); expectation.fulfill() }
            .store(in: &cancellables)
        
        viewModel.slotEmoji1 = "❌"
        viewModel.slotEmoji2 = "❌"
        viewModel.slotEmoji3 = "❌"
        
        viewModel.running = false
        viewModel.gameStart = true
        
        wait(for: [expectation], timeout: 1)
    }
}


