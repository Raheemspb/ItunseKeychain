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

    func saveAlbumToDisk(_ albums: [Album]) {
        do {
            try Disk.save(albums, to: .documents, as: "Albums.json")
            print("Albums saved to disk")
        } catch {
            print("Error saving albums: ", error.localizedDescription)
        }
    }

    func getAlbumsFromDisk() -> [Album]? {
        do {
            let albums = try Disk.retrieve("Albums.json", from: .documents, as: [Album].self)
            print("Albums retrieved from disk")
            return albums
        } catch {
            print("Error retrieving albums: ", error.localizedDescription)
            return nil
        }
    }

    func saveSearchTextToDisk(searchText: String) {
        do {
            var searchTexts = getSearchTextFromDisk() ?? []
            searchTexts.append(searchText)
            try Disk.save(searchTexts, to: .documents, as: "searchText.json")
            print("Saved searchText to disk")
        } catch {
            print("Error saving search text: ", error.localizedDescription)
        }
    }

    func getSearchTextFromDisk() -> [String]? {
        do {
            let searchTexts = try Disk.retrieve("searchText.json", from: .documents, as: [String].self)
            print("Search text retrieved from disk")
            return searchTexts
        } catch {
            print("Error retrieving search text: ", error.localizedDescription)
            return nil
        }
    }
}
