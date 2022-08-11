//: [Previous](@previous)

import Foundation
import Combine

public func example(of description: String, action: () -> Void) {
    print("\n------ Example of:", description, "------")
    action()
}

private var cancellables = Set<AnyCancellable>()

/*
 1. Реализовать с помощью Combine простейший клиент, который обращается к открытому API. (Минимальное количество методов API: 2)
 2. Реализовать отладку любых двух издателей в коде.
 */

// MARK: - Data models

public struct Character: Codable {
    
    public var id: Int64
    public var name: String
    public var status: String
    public var species: String
    public var type: String
    public var gender: String
    public var image: String
    
    public init(id: Int64, name: String, status: String, species: String, type: String, gender: String, image: String) {
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.type = type
        self.gender = gender
        self.image = image
    }

}

public struct CharacterPage: Codable {
    
    public var info: PageInfo
    public var results: [Character]
    
    public init(info: PageInfo, results: [Character]) {
        self.info = info
        self.results = results
    }

}

public struct PageInfo: Codable {
    
    public var count: Int
    public var pages: Int
    public var prev: String?
    public var next: String?

    public init(count: Int, pages: Int, prev: String?, next: String?) {
        self.count = count
        self.pages = pages
        self.prev = prev
        self.next = next
    }

}

// MARK: - Episode models

public struct Episode: Codable {
    
    public var id: Int
    public var name: String
    public var airDate: String
    public var episode: String
    
    public init(id: Int, name: String, airDate: String, episode: String) {
        self.id = id
        self.name = name
        self.airDate = airDate
        self.episode = episode
    }
    
}

public struct EpisodePage: Codable {
    
    public var info: PageInfo
    public var results: [Episode]
    
    public init(info: PageInfo, results: [Episode]) {
        self.info = info
        self.results = results
    }
}

struct APIClient {
    
    enum Method {
        static let baseURL = URL(string: "https://rickandmortyapi.com/api/")!

        case character(Int)
        //case location
        case episode(Int)
        
        var url: URL {
            switch self {
            case .character(let id):
                return Method.baseURL.appendingPathComponent("character/\(id)")
            case .episode(let id):
                return Method.baseURL.appendingPathComponent("episode/\(id)")
            }
        }
    }
    
    enum Error: LocalizedError {
        case unreachableAddress(url: URL)
        case invalidResponse
        
        var errorDescription: String? {
            switch self {
            case .unreachableAddress(let url):
                return "\(url.absoluteString) is unreachable"
            case .invalidResponse:
                return "Response with mistake" }
        }
    }
    
    private let decoder = JSONDecoder()
    private let queue = DispatchQueue(label: "APIClient",
                                      qos: .default,
                                      attributes: .concurrent)
    
    func fetchCharacter(id: Int) -> AnyPublisher<Character, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: Method.character(id).url)
            .receive(on: queue)
            .map(\.data)
            .decode(type: Character.self, decoder: decoder)
            .mapError { (error) -> Error in
                switch error {
                case is URLError:
                    return Error.unreachableAddress(url: Method.character(id).url)
                default:
                    return Error.invalidResponse
                }
            }
            .eraseToAnyPublisher()
    }
    
    func fetchEpisode(id: Int) -> AnyPublisher<Episode, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: Method.episode(id).url)
            .receive(on: queue)
            .map { $0.data }
            .decode(type: Episode.self, decoder: decoder)
            .mapError { (error) -> Error in
                switch error {
                case is URLError:
                    return Error.unreachableAddress(url: Method.episode(id).url)
                default:
                    return Error.invalidResponse
                }
            }
            .eraseToAnyPublisher()
    }
    
    func fetchSeveralEpisodes(ids: [Int]) -> AnyPublisher<Episode, Error> {
        precondition(!ids.isEmpty)
        
        let initiatPublesher = fetchEpisode(id: ids[0])
        let remainder = Array(ids.dropFirst())
        
        return remainder.reduce(initiatPublesher) { (combined, id) in
            return combined
                .merge(with: fetchEpisode(id: id))
                .eraseToAnyPublisher()
        }
    }
    
}



// MARK: - Debugger

class TimeLogger: TextOutputStream {
    
    private var previous = Date()
    private let formatter = NumberFormatter()
    
    init() {
        formatter.maximumFractionDigits = 5
        formatter.minimumFractionDigits = 5
    }
    
    func write(_ string: String) {
        let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let now = Date()
        print("+\(formatter.string(for: now.timeIntervalSince(previous))!)s: \(string)")
        previous = now
    }
    
}

// MARK: - Example

let apiClient = APIClient()

apiClient.fetchCharacter(id: 10)
    .print("Character publisher", to: TimeLogger())
    .sink(receiveCompletion: { print($0) }, receiveValue: { print($0) })
    .store(in: &cancellables)

apiClient.fetchEpisode(id: 8)
    .print("Episode publisher", to: TimeLogger())
    .handleEvents(
        receiveCompletion: { completion in
            if case .failure(let error) = completion {
                print(error.localizedDescription)
            }
        }
    )
    .sink(receiveCompletion: { print($0) }, receiveValue: { print($0) })
    .store(in: &cancellables)

apiClient.fetchSeveralEpisodes(ids: [1, 10, 30,50])
    .handleEvents(
        receiveSubscription: { print("Subscription: \($0)") },
        receiveOutput: { print("Output: \($0)") },
        receiveCancel: { print("Subscription was canceled") },
        receiveRequest: { print("Subscription demand: \($0)") })
    .sink(
        receiveCompletion: { completion in
            if case .failure(let error) = completion {
                print(error.localizedDescription)
            } else { print(completion) }
        },
        receiveValue: { print($0)}
    )
    .store(in: &cancellables)

//: [Next](@next)
