//
//  FavoritesViewController.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 24.08.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    // MARK: - Class instances
        
    /// View model
    public var viewModel: FavoritesViewModelProtocol?
    
    /// Reuse identifier for cell
    private let reuseIdentifier = "Cell"
    
    // MARK: - Outlets
    
    /// Table view outlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Class life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchContactsData()
        showError()
    }
    
    // MARK: - Class methods
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: true)
    }
    
    /// Setup view
    private func setupView() {
        title = "Favorites.Title".localized
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    /// Get favorites contacts from view model
    private func fetchContactsData() {
        viewModel?.fetchFavoritesContacts()
        viewModel?.updateView = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    /// Displays an error if it appears
    private func showError() {
        viewModel?.error = { [weak self] message in
            self?.showError(message: message)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func addContactButtonPressed(_ sender: Any) {
        viewModel?.showAddContactController ()
    }
}

// MARK: - TableViewDelegate

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.showDetailsContact(at: indexPath.row)
    }
}

// MARK: - TableViewDataSource

extension FavoritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        viewModel?.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .right)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        viewModel?.move(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRowsInSection() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = viewModel?.getContactName(at: indexPath.row)
        return cell
    }
}
