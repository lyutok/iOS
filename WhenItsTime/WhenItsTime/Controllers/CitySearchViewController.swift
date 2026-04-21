//
//  CitySearchViewController.swift
//  WhenItsTime
//
//  Created by Lyudmila Tokar on 3/18/26.
//

import UIKit

protocol CitySearchDelegate: AnyObject {
    func didSelectCity(_ city: CityItem)
}

class CitySearchViewController: UITableViewController {
    
    weak var delegate: CitySearchDelegate?
    
    // MARK: - Properties
    private var searchController = UISearchController(searchResultsController: nil)
//    private var allCities: [String] = []
//    private var filteredCities: [String] = []
    private var allCities: [CityItem] = []
    private var filteredCities: [CityItem] = []
    
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 105/255, green: 181/255, blue: 190/255, alpha: 0.3)
        appearance.shadowColor = .clear
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupSearchController()
        loadCities()
        
        tableView.backgroundColor = UIColor(red: 105/255, green: 181/255, blue: 190/255, alpha: 0.2)
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
            .compactMap { identifier -> CityItem? in
                let parts = identifier.split(separator: "/")
                guard parts.count >= 2 else { return nil }
                let countryCode = timeZoneToCountryCode[identifier] ?? ""
                let country = Locale.current.localizedString(forRegionCode: countryCode) ?? String(parts[0])
                let city = parts.last!.replacingOccurrences(of: "_", with: " ")
                
                return CityItem(displayName: "\(city) (\(country))", identifier: identifier, city: city)
            }
            .sorted { $0.displayName < $1.displayName }
        
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
                $0.displayName.lowercased().contains(searchText.lowercased())
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
        cell.textLabel?.text = filteredCities[indexPath.row].displayName
        cell.backgroundColor = UIColor(red: 105/255, green: 181/255, blue: 190/255, alpha: 0.3)
        cell.selectionStyle = .none
        return cell
    }
}


// MARK: - UITableViewDelegate
extension CitySearchViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = filteredCities[indexPath.row]
        print("City: \(selected.city)")
        print("Identifier: \(selected.identifier)")
        delegate?.didSelectCity(selected)
        searchController.dismiss(animated: false)
        dismiss(animated: true)
    }
}
