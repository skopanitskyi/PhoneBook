//
//  AddContactViewController.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 25.09.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit

class AddContactViewController: UIViewController {
    
    // MARK: - Class instances
    
    private let identifier = "Cell"
    
    public var viewModel: AddContactViewModelProtocol?
    
    // MARK: - Outlets

    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Class life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getContactsData()
        showError()
    }
    
    // MARK: - Actions
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        viewModel?.cancel()
    }
    
    // MARK: - Class methods
    
    /// Get contact data from view model
    private func getContactsData() {
        viewModel?.updateView = { [weak self] in
            self?.tableView.reloadData()
        }
        viewModel?.fetchContacts()
    }
    
    /// Displays an error if it appears
    private func showError() {
        viewModel?.error = { [weak self] message in
            self?.showError(message: message)
        }
    }
}

// MARK: - TableViewDelegate

extension AddContactViewController: UITableViewDelegate {
    
}

// MARK: - TableViewDataSource

extension AddContactViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRowsInSection() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! AddContactTableViewCell
        cell.name = viewModel?.getContactName(at: indexPath.row)
        cell.delegate = self
        return cell
    }
}

// MARK: - AddContactCellDelegate

extension AddContactViewController: AddContactCellDelegate {
    func deleteCell(at name: String) {
        if let index = viewModel?.deleteCell(at: name) {
            let indexPath = IndexPath(row: index, section: 0)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .right)
            tableView.endUpdates()
        }
    }
}
