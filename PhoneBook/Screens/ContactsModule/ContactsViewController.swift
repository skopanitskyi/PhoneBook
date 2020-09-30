//
//  ContactsViewController.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 30.07.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController {
    
    // MARK: - Class instances
    
    /// Reuse identifier for cells
    private let reuseIdentifier = "Cell"
    
    /// Contacts view model
    public var viewModel: ContactsViewModelProtocol!
    
    /// Returns true if search bar is empty
    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    /// Returns true if data is entered into the search controller
    private var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    // MARK: - Create UI elements
    
    /// Create table view
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    /// Create search controller
    private var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Contacts.SearchBarPlaceholder".localized
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()
    
    /// Create sorting button
    private var sortingButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "I"), for: .normal)
        return button
    }()
    
    // MARK: - Class life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupView()
        setupTableView()
    }
    
    // MARK: - Setup UI elements
    
    /// Setup view
    private func setupView() {
        view.backgroundColor = .white
        title = "Contacts.Title".localized
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        navigationController?.navigationBar.prefersLargeTitles = true
        sortingButton.addTarget(self, action: #selector(sortingButtonTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sortingButton)
        navigationItem.searchController = searchController
    }
    
    /// Add table view and setup constraints
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    // MARK: - Class methods
    
    /// Sorts contacts alphabetically
    @objc private func sortingButtonTapped() {
        let alertController = UIAlertController(title: "Contacts.AlertTitile".localized, message: "Contacts.AlertMessage".localized, preferredStyle: .actionSheet)
        
        let ascending = UIAlertAction(title: "Contacts.AllertAscending".localized, style: .default) { _ in
            self.sortingButton.setImage(UIImage(named: "I"), for: .normal)
            self.viewModel.reverse(isAscending: true)
        }
        
        let descending = UIAlertAction(title: "Contacts.AllertDescending".localized, style: .default) { _ in
            self.sortingButton.setImage(UIImage(named: "I1"), for: .normal)
            self.viewModel.reverse(isAscending: false)
        }
        
        let cancel = UIAlertAction(title: "Common.Cancel".localized, style: .cancel)
        
        alertController.addAction(ascending)
        alertController.addAction(descending)
        alertController.addAction(cancel)
        
        alertController.pruneNegativeWidthConstraints()
        present(alertController, animated: true, completion: nil)
    }
    
    /// Load contacts data
    private func loadData() {
        viewModel.fetchContactsData()
        viewModel.updateTableView = { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

// MARK: - TableViewDelegate

extension ContactsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.makeCall(at: indexPath)
    }
}

// MARK: - TableViewDataSource

extension ContactsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.isFiltering = isFiltering
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForHeaderInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        let contact = viewModel.getContact(at: indexPath)
        cell.textLabel?.text = contact.fullName
        return cell
    }
}

// MARK: - SearchResultsUpdating

extension ContactsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let contactName = searchController.searchBar.text?.lowercased() {
            viewModel.getFilteredContacts(name: contactName)
        }
    }
}
