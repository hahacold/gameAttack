//
//  gamesDataFetcher.swift
//  gameAttack
//
//  Created by test on 2023/12/20.
//

import Foundation
//struct gameSearchResponse: Codable {
//    let results: [GamesItem]
//}

//struct GamesItem: Codable, Identifiable {
//    var id: Int
//    let title: String
//    let image: String
//    let platforms: String
//    let description: String
//    //"worth": "$7.99"
////    let trackId: Int
////    let trackName: String
////    let artistName: String
//    let worth: String
//}
struct GamesItem: Codable, Identifiable {
    var id: Int
    let title: String
    let thumbnail: String
    let platform: String
    let short_description: String
    let game_url: String
    //"worth": "$7.99"
//    let trackId: Int
//    let trackName: String
//    let artistName: String
}

@Observable class GamesDataFetcher {
    var items = [GamesItem]()
    var favoritems = [GamesItem]()
    enum FetchError: Error {
        case invalidURL
        case badRequest
    }
    
    func fetchData(term: String) async throws {
        print("start")
//        let urlString = "https://itunes.apple.com/search?term=\(term)&media=music&country=tw"
        let urlString = "https://www.freetogame.com/api/games"
        guard let url = URL(string: urlString) else {
            throw FetchError.invalidURL
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw FetchError.badRequest
        }
        let searchResponse = try JSONDecoder().decode([GamesItem].self, from: data)
        // 寫法 1
        //print(searchResponse)
        items = searchResponse
        print("sucess")
        
        
//        寫法 2
//        Task { @MainActor in
//            items = searchResponse.results
//        }
    }
    func fetchidData(term: Int) async throws {
        print("start")
//        let urlString = "https://itunes.apple.com/search?term=\(term)&media=music&country=tw"
        let urlString = "https://www.freetogame.com/api/game?id=\(term)"
        guard let url = URL(string: urlString) else {
            throw FetchError.invalidURL
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw FetchError.badRequest
        }
        let searchResponse = try JSONDecoder().decode(GamesItem.self, from: data)
        // 寫法 1
        //print(searchResponse)
        favoritems.append(searchResponse)
        
        
//        寫法 2
//        Task { @MainActor in
//            items = searchResponse.results
//        }
    }
}


