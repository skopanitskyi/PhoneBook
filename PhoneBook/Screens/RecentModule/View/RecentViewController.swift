//
//  RecentViewController.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 04.08.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit

class RecentViewController: UIViewController {
    
    public var viewModel: RecentViewModelProtocol!
    
    private let reuseIdentifier = "Cell"
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Recent.Title".localized
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = editButtonItem
        let leftButton = UIBarButtonItem(title: "Recent.LeftButton.Delete".localized,
                                         style: .plain,
                                         target: self,
                                         action: #selector(deleteRecentsContacts))
        leftButton.isEnabled = false
        navigationItem.leftBarButtonItem = leftButton
        setupTableView()
        viewModel.downloadData()
        viewModel.updateView = { [weak self] in
            self?.tableView.reloadData()
        }
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
    
    @objc private func deleteRecentsContacts() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAll = UIAlertAction(title: "Очистить все недавние", style: .destructive) { [weak self] action in
            self?.viewModel.deleteAllContacts()
        }
        let cancel = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
        
        alertController.addAction(deleteAll)
        alertController.addAction(cancel)
        alertController.pruneNegativeWidthConstraints()

        present(alertController, animated: true, completion: nil)
    }
}

extension RecentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.showDetailsContact(at: indexPath.row)
    }
}

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
