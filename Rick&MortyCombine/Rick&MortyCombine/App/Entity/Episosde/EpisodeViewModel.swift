//
//  EpisodeViewModel.swift
//  Rick&MortyCombine
//
//  Created by Мария Коханчик on 18.08.2022.
//

import Foundation
import SwiftUI
import Combine

class EpisodeViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published private var allEpisodes: [Episode] = []
    
    var episodes: [Episode] = []
    
    private var apiClient = APIClient()
    private var currentPage: Int = 0
    
    private var subscriptions: Set<AnyCancellable> = []
    @Published var error: APIClient.NetworkError? = nil
    
    var lastUpdateTime: TimeInterval = Date().timeIntervalSince1970
    
    // MARK: - Methods
    
    func fetchEpisodes() {
        apiClient
            .page(num: currentPage + 1)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.error = error
                }
            }, receiveValue: { page in
                self.lastUpdateTime = Date().timeIntervalSince1970
                //self.allEpisodes.append(contentsOf: page.results)
                self.currentPage += 1
                self.error = nil
            })
            .store(in: &subscriptions)
    }
}
