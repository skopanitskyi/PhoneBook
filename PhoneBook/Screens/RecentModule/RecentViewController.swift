//
//  RecentViewController.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 04.08.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit

class RecentViewController: UIViewController {
    
    // MARK: - Class instances
    
    /// View model
    public var viewModel: RecentViewModelProtocol!
    
    /// Reuse identifier for cell
    private let reuseIdentifier = "Cell"
    
    // MARK: - Create UI elements
    
    /// Create table view
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    /// Create left button
    private lazy var leftButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Recent.LeftButton.Delete".localized,
                                     style: .plain,
                                     target: self,
                                     action: #selector(deleteRecentsContacts))
        button.isEnabled = false
        return button
    }()
    
    // MARK: - Class life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        fetchRecentData()
        showError()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: true)
        
        if editing {
            navigationItem.leftBarButtonItem?.isEnabled = true
        } else {
            navigationItem.leftBarButtonItem?.isEnabled = false
        }
    }
    
    // MARK: - Add UI elements and setup view
    
    /// Setup view
    private func setupView() {
        title = "Recent.Title".localized
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = editButtonItem
        navigationItem.leftBarButtonItem = leftButton
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
    
    /// Fetch recent contacts data from view model
    private func fetchRecentData() {
        viewModel.downloadData()
        viewModel.updateView = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    /// Displays an error if it appears
    private func showError() {
        viewModel.error = { [weak self] message in
            self?.showError(message: message)
        }
    }
    
    /// Delete all recents contacts
    @objc private func deleteRecentsContacts() {
        
        self.showAlert(title: nil,
                       message: nil,
                       leftButton: "Recent.AlertController.DeleteAllContacts".localized,
                       rightButton: nil,
                       cancel: true,
                       style: .actionSheet) { [weak self] isDelete in
            if isDelete {
                self?.viewModel.deleteAllContacts()
            }
        }
    }
}

// MARK: - TableViewDelegate

extension RecentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.showDetailsContact(at: indexPath.row)
    }
}

// MARK: - TableViewDataSource

extension RecentViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        viewModel.deleteContact(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = viewModel.getContactName(at: indexPath.row)
        return cell
    }
}
