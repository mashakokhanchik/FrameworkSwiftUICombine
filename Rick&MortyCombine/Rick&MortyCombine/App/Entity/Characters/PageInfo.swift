//
//  PageInfo.swift
//  Rick&MortyCombine
//
//  Created by Мария Коханчик on 12.08.2022.
//

import Foundation

// MARK: - Page with information

public struct PageInfo: Codable {

    public var count: Int
    public var pages: Int
    public var prev: String?
    public var next: String?

    public init(
        count: Int,
        pages: Int,
        prev: String?,
        next: String?
    ) {
        self.count = count
        self.pages = pages
        self.prev = prev
        self.next = next
    }

}
