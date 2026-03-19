//
//  CitySearchViewController.swift
//  WhenItsTime
//
//  Created by Lyudmila Tokar on 3/18/26.
//

import UIKit

class CitySearchViewController: UITableViewController {
    
    // MARK: - Properties
    private var searchController = UISearchController(searchResultsController: nil)
    private var allCities: [String] = []
    private var filteredCities: [String] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupSearchController()
        loadCities()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CityCell")
    }
    
    // MARK: - Setup
    private func setupNavigationBar() {
        title = "Choose City"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelTapped)
        )
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search city..."
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func loadCities() {
        allCities = TimeZone.knownTimeZoneIdentifiers
                .compactMap { identifier -> String? in
                    let parts = identifier.split(separator: "/")
                    guard parts.count >= 2 else { return nil }
                    let region = String(parts[0])
                    let city = parts.last!.replacingOccurrences(of: "_", with: " ")
                    return "\(city) (\(region))"
                }
                .sorted()
        
        filteredCities = allCities
        tableView.reloadData()
    }
    
    // MARK: - Actions
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
}


// MARK: - UISearchResultsUpdating
extension CitySearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        
        if searchText.isEmpty {
            filteredCities = allCities
        } else {
            filteredCities = allCities.filter {
                $0.lowercased().contains(searchText.lowercased())
            }
        }
        
        tableView.reloadData()
    }
}


// MARK: - UITableViewDataSource
extension CitySearchViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
        cell.textLabel?.text = filteredCities[indexPath.row]
        return cell
    }
}
