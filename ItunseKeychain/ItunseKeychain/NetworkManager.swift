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
    let keychain = KeychainSwift()

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

        do {
            let encodedAlbum = try JSONEncoder().encode(albums)
            keychain.set(encodedAlbum, forKey: "album.json")
            print("ALbums saved to Keychain")
        } catch {
            print("Error saving albums to keychain", error.localizedDescription)
        }
    }

    func getAlbumsFromKeychain() -> [Album]? {

        guard let savedData = keychain.getData("album.json") else {
            print("No character found in keychain")
            return nil
        }

        do {
            let albums = try JSONDecoder().decode([Album].self, from: savedData)
            print("Albums loaded from Keychan")
            return albums
        } catch {
            print("Error loading albums from Keychain")
            return nil
        }
    }

    func saveSearchTextToKeychain(searchText: String) {

        
    }

    func getSearchTextFromKeychain() -> [String]? {

        return nil
    }
}
