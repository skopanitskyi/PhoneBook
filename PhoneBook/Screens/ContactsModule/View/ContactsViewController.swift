//
//  ContactsViewController.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 30.07.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController {
    
    private let reuseIdentifier = "Cell"
    
    public var viewModel: ContactsViewModelProtocol!
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search the contact"
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()
    
    private var sortingButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "I"), for: .normal)
        return button
    }()
    
    /// Returns true if search bar is empty
    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    /// Returns true if data is entered into the search controller
    private var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupView()
        setupTableView()
    }
    
    private func loadData() {
        viewModel.fetchContactsData()
        viewModel.updateTableView = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
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
}

extension ContactsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.makeCall(at: indexPath)
    }
}

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

extension ContactsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let contactName = searchController.searchBar.text?.lowercased() {
            viewModel.getFilteredContacts(name: contactName)
        }
    }
}
