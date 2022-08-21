//
//  APIClient.swift
//  Rick&MortyCombine
//
//  Created by Мария Коханчик on 12.08.2022.
//

import Foundation
import Combine

struct APIClient {
    
    // MARK: - Methods enumeration API
    
    enum Method {
        static let baseURL = URL(string: "https://rickandmortyapi.com/api/")!
        static let characterPath = "character/"
        static let episodePath = "episode/"
        
        case page(Int)
        case character(Int)
        case location
        case episode(Int)
        
        var url: URL {
            switch self {
            case .page(let num):
                let urlString = Method.baseURL.appendingPathComponent(Method.characterPath).absoluteString
                var urlComps = URLComponents(string: urlString)
                urlComps?.queryItems = [URLQueryItem(name: "page", value: "\(num)")]
                return urlComps?.url ?? Method.baseURL
            case .character(let id):
                return Method.baseURL.appendingPathComponent(Method.characterPath + String(id))
            case .episode(let id):
                return Method.baseURL.appendingPathComponent(Method.episodePath + String(id))
            default:
                fatalError("URL for this case is undefined.")
            }
        }
    }
    
    // MARK: - Error handling enumeration
    
    enum NetworkError: LocalizedError, Identifiable {
        var id: String { localizedDescription }
        
        case unreachableAddress(url: URL)
        case invalidResponse
        
        var errorDescription: String? {
            switch self {
            case .unreachableAddress(let url): return "\(url.absoluteString) is unreachable"
            case .invalidResponse: return "Response with mistake"
            }
        }
    }
    
    // MARK: - Making API request
    
    private let decoder = JSONDecoder()
    private let queue = DispatchQueue(label: "APIClient", qos: .default, attributes: .concurrent)
    
    func page(num: Int) -> AnyPublisher<Page, NetworkError> {
        return URLSession.shared
            .dataTaskPublisher(for: Method.page(num).url)
            .handleEvents()
            .receive(on: queue)
            .map(\.data)
            .decode(type: Page.self, decoder: decoder)
            .mapError({ error -> NetworkError in
                switch error {
                case is URLError:
                    return NetworkError.unreachableAddress(url: Method.page(num).url)
                default:
                    return NetworkError.invalidResponse
                }
            })
            .eraseToAnyPublisher()
    }
    
    /// Characters
    
    func character(id: Int) -> AnyPublisher<Character, NetworkError> {
        return URLSession.shared
            .dataTaskPublisher(for: Method.character(id).url)
            .receive(on: queue)
            .map(\.data)
            .decode(type: Character.self, decoder: decoder)
            .mapError({ error -> NetworkError in
                switch error {
                case is URLError:
                    return NetworkError.unreachableAddress(url: Method.character(id).url)
                default:
                    return NetworkError.invalidResponse
                }
            })
            .eraseToAnyPublisher()
    }
    
    /// Loading multiple characters in parallel
    
    func mergedCharacters(ids: [Int]) -> AnyPublisher<Character, NetworkError> {
        precondition(!ids.isEmpty)
        
        let initialPublisher = character(id: ids[0])
        let remainder = Array(ids.dropFirst())
        
        return remainder.reduce(initialPublisher) { (combined, id) in
            return combined
                .merge(with: character(id: id))
                .eraseToAnyPublisher()
        }
    }
    
    /// Episodes
    
    func episode(id: Int) -> AnyPublisher<Episode, NetworkError> {
        return URLSession.shared
            .dataTaskPublisher(for: Method.episode(id).url)
            .receive(on: queue)
            .map(\.data)//{ $0.data }
            .decode(type: Episode.self, decoder: decoder)
            .mapError { error -> NetworkError in
                switch error {
                case is URLError:
                    return NetworkError.unreachableAddress(url: Method.episode(id).url)
                default:
                    return NetworkError.invalidResponse
                }
            }
            .eraseToAnyPublisher()
    }
    
    func mergetEpisodes(ids: [Int]) -> AnyPublisher<Episode, NetworkError> {
        precondition(!ids.isEmpty)
        
        let initiatPublesher = episode(id: ids[0])
        let remainder = Array(ids.dropFirst())
        
        return remainder.reduce(initiatPublesher) { (combined, id) in
            return combined
                .merge(with: episode(id: id))
                .eraseToAnyPublisher()
        }
    }
}

