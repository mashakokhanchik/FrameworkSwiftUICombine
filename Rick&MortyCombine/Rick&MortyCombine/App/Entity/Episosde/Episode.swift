//
//  Episode.swift
//  Rick&MortyCombine
//
//  Created by Мария Коханчик on 18.08.2022.
//

import Foundation

// MARK: - Basic information about the episode

public struct Episode: Codable, Identifiable {
    
    public var id: Int
    public var name: String
    public var airDate: String
    public var episode: String
    
    public init(
        id: Int,
        name: String,
        airDate: String,
        episode: String
    ) {
        self.id = id
        self.name = name
        self.airDate = airDate
        self.episode = episode
    }
    
}
