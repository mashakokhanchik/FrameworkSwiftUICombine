//
//  CharactersViewModel.swift
//  Rick&MortyCombine
//
//  Created by Мария Коханчик on 12.08.2022.
//

import Foundation
import SwiftUI
import Combine

class CharactersViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published private var allCharacters: [Character] = []
    @Published var error: APIClient.NetworkError? = nil
    @Published var filterTags: [Tag] = []
    
    var filterText: String {
        guard let lastFilter = filterTags.last else { return "All characters"}
        return filterTags.dropLast().reduce(into: "Filter: ") { result, tag in
            result += tag.rawValue + ", "
        } + lastFilter.rawValue
    }
    
    var lastUpdateTime: TimeInterval = Date().timeIntervalSince1970
    
    private var apiClient = APIClient()
    private var currentPage: Int = 0
    
    private var subscriptions: Set<AnyCancellable> = []
    
    var characters: [Character] {
        guard !filterTags.isEmpty else {
            return allCharacters
        }
        
        return allCharacters
            .filter { (character) -> Bool in
                return filterTags.reduce(false) { (isMatch, tag) -> Bool in
                    self.checkMatching(character: character, for: tag)
                }
            }
    }
    
    // MARK: - Private methods
    
    private func checkMatching(character: Character, for tag: Tag) -> Bool {
        switch tag {
        case .alive, .dead:
            return character.status.lowercased() == tag.rawValue.lowercased()
        case .female, .male, .genderless:
            return character.gender.lowercased() == tag.rawValue.lowercased()
        }
    }

    // MARK: - Methods
    
    func fetchCharacters() {
        apiClient
            .page(num: currentPage + 1)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.error = error
                }
            }, receiveValue: { page in
                self.lastUpdateTime = Date().timeIntervalSince1970
                self.allCharacters.append(contentsOf: page.results)
                self.currentPage += 1
                self.error = nil
            })
            .store(in: &subscriptions)
    }

}

