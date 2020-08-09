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
    
    private let filteredContacts = FilteredContactsViewController()
    
    public var viewModel: ContactsViewModelProtocol!
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var searchController: UISearchController = {
        let searchController = UISearchController()
        return searchController
    }()
    
    private var sortingButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Sort", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
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
        title = "Contacts"
        searchController.searchBar.delegate = self
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
        let alertController = UIAlertController(title: "Sort contacts", message: "Choose", preferredStyle: .actionSheet)
        
        let alertAction1 = UIAlertAction(title: "Z-A", style: .default) { _ in
            self.viewModel.reverse(isAlpabetic: false)
        }
        let alertAction = UIAlertAction(title: "A-Z", style: .default) { _ in
            self.viewModel.reverse(isAlpabetic: true)
        }
        
        let alertAction2 = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(alertAction)
        alertController.addAction(alertAction1)
        alertController.addAction(alertAction2)
        alertController.pruneNegativeWidthConstraints()
        present(alertController, animated: true, completion: nil)
    }
}

extension ContactsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = viewModel.getContact(at: indexPath)
        let phoneNumber = contact.phoneNumber.removeWhitespaces()
        if let url = URL(string: "tel://\(phoneNumber)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            viewModel.addToRecent(contact: contact)
        }
    }
}

extension ContactsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
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

extension ContactsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if view.subviews.count == 1 {
            addChild(filteredContacts)
            view.addSubview(filteredContacts.view)
            filteredContacts.didMove(toParent: self)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredContacts.willMove(toParent: nil)
        filteredContacts.view.removeFromSuperview()
        filteredContacts.removeFromParent()
    }
}
