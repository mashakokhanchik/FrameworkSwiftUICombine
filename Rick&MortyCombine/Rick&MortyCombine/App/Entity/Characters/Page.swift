//
//  Page.swift
//  Rick&MortyCombine
//
//  Created by Мария Коханчик on 12.08.2022.
//

import Foundation

// MARK: - Information about the received page and all characters

public struct Page: Codable {

    public var info: PageInfo
    public var results: [Character]

    public init(
        info: PageInfo,
        results: [Character]
    ) {
        self.info = info
        self.results = results
    }

}
