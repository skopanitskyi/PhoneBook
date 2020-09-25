//
//  AddContactViewController.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 25.09.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit

class AddContactViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let identifier = "Cell"
    
    public var viewModel: AddContactViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.updateView = { [weak self] in
            self?.tableView.reloadData()
        }
        viewModel?.fetchContacts()
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        viewModel?.cancel()
    }
}

extension AddContactViewController: UITableViewDelegate {
    
}

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
