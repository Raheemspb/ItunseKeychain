//
//  NetworkManager.swift
//  ItunseKeychain
//
//  Created by Рахим Габибли on 21.07.2024.
//

import Foundation
import KeychainSwift

struct AlbumName: Codable {
    let results: [Album]
}

struct Album: Codable {
    let artistName: String
    let collectionName: String
    let artworkUrl100: String
    let trackCount: Int
}

class NetworkManager {

    static let shared = NetworkManager()

    func fetchAlbum(albumName: String) -> String {
        let url = "https://itunes.apple.com/search?term=\(albumName)&entity=album&attribute=albumTerm"
        return url
    }

    func getCharacter(albumName: String, completionHandler: @escaping ([Album]) -> Void) {
        let urlString = fetchAlbum(albumName: albumName)
        guard let url = URL(string: urlString) else {
            print("Error")
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error:", error.localizedDescription)
                return
            }

            guard let data else {
                print("No data")
                return
            }

            do {
                let album = try JSONDecoder().decode(AlbumName.self, from: data).results
                completionHandler(album)
            } catch {
                print("Error: ", error.localizedDescription)
            }
        }.resume()
    }

    func saveAlbumToKeychain(_ albums: [Album]) {

    }

    func getAlbumsFromKeychain() -> [Album]? {

        return nil
    }

    func saveSearchTextToKeychain(searchText: String) {

    }

    func getSearchTextFromKeychain() -> [String]? {

        return nil
    }
}
