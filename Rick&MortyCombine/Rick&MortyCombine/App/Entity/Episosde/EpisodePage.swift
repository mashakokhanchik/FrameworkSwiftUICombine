//
//  EpisodePage.swift
//  Rick&MortyCombine
//
//  Created by Мария Коханчик on 18.08.2022.
//

import Foundation

// MARK: - Information about the received page and all episodes

public struct EpisodePage: Codable {
    
    public var info: PageInfo
    public var results: [Episode]
    
    public init(
        info: PageInfo,
        results: [Episode]
    ) {
        self.info = info
        self.results = results
    }
}
