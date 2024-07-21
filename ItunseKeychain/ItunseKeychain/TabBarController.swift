//
//  TabBarController.swift
//  ItunseKeychain
//
//  Created by Рахим Габибли on 21.07.2024.
//

import UIKit

class TabBarController: UITabBarController {

    var searchBar = UISearchBar()
    let networkManager = NetworkManager()
    let searchHistoryViewController = SearchHistoryViewController()
    let viewController = ViewController()
    var albums = [Album]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViewControllers()
        setupSearchBar()
        if let searchTexts = networkManager.getSearchTextFromKeychain() {
            performInitialSearch(with: searchTexts.last!)
        }
    }

    private func setupSearchBar() {
        searchBar.placeholder = "Search"
        searchBar.delegate = self

        if let navController = viewControllers?.first as? UINavigationController {
            navController.navigationBar.topItem?.titleView = searchBar
        }
    }

    private func setupViewControllers() {
        let searchNavController = UINavigationController(rootViewController: viewController)
        searchNavController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 0)

        let historyNavController = UINavigationController(rootViewController: searchHistoryViewController)
        historyNavController.tabBarItem = UITabBarItem(title: "History", image: UIImage(systemName: "clock"), tag: 1)

        viewControllers = [searchNavController, historyNavController]

    }

    func performInitialSearch(with searchText: String) {
       searchBar.text = searchText
       searchBarSearchButtonClicked(searchBar)
   }
}


extension TabBarController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            return
        }

        networkManager.getCharacter(albumName: searchText) { [weak self] albums in

            if let getAlbums = self?.networkManager.getAlbumsFromKeychain() {
                print("getAlbums count", getAlbums.count)
                self?.albums = getAlbums
                if let searchTexts = self?.networkManager.getSearchTextFromKeychain() {
                    self?.searchHistoryViewController.searchHistory = searchTexts
                }
            } else {
                self?.albums = albums
            }

            self?.networkManager.saveAlbumToKeychain(albums)
            self?.networkManager.saveSearchTextToKeychain(searchText: searchText)
            DispatchQueue.main.async {
                self?.viewController.albums = albums
                self?.viewController.collectionView.reloadData()
                self?.searchHistoryViewController.tableView.reloadData()
            }
        }

//        searchBar.resignFirstResponder()
    }
}
