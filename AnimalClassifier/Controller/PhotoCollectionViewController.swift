//
//  PhotoCollectionViewController.swift
//  AnimalClassifier
//
//  Created by yauheni prakapenka on 16.11.2019.
//  Copyright © 2019 yauheni prakapenka. All rights reserved.
//

import UIKit

class PhotoCollectionViewController: UICollectionViewController {
    
    // MARK: - Input
    
    let networkDataFetcher = NetworkDataFetcher()
    private var timer: Timer?
    
    // MARK: - Subview
    
    private lazy var addBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped))
    }()
    
    private lazy var actionBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionBarButtonTapped))
    }()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        setupNavigationBar()
        setupCollectionView()
        setupSearchBar()
    }
    
    // MARK: - NavigationItems action
    
    @objc
    private func addBarButtonTapped() {
        print(#function)
    }
    
    @objc
    private func actionBarButtonTapped() {
        print(#function)
    }
    
    // MARK: - Setup UI Elements
    
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "Unsplash"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .gray
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
        
        navigationItem.rightBarButtonItems = [actionBarButtonItem, addBarButtonItem]
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    private func setupCollectionView() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CellId")
    }
    
    // MARK: - UICollectionViewDataSource, UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
}

// MARK: - UISearchBarViewControlelr

extension PhotoCollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // print(searchText)
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.networkDataFetcher.fetchImage(searchTerm: searchText) { (searchResultModel) in
                searchResultModel?.results.map({ (photo) in
                    print(photo.urls["small"])
                })
            }
        })
    }
}
