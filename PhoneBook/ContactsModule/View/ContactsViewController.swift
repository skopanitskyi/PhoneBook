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
        let searchController = UISearchController()
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupView()
        setupTableView()
    }
    
    private func loadData() {
        viewModel?.fetchContactsData()
        viewModel.updateTableView = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func setupView() {
        view.backgroundColor = .white
        title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true
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
}

extension ContactsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let phoneNumber = viewModel.contacts[indexPath.section][indexPath.row].phoneNumber.removeWhitespaces()
        if let url = URL(string: "tel://\(phoneNumber)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

extension ContactsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.contacts.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let title = viewModel.contacts[section].first?.fullName.first?.uppercased() {
            return title
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.contacts[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = viewModel.contacts[indexPath.section][indexPath.row].fullName
        return cell
    }
}

extension String {
    func removeWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}
