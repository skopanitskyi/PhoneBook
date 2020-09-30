//
//  AddContactTableViewCell.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 25.09.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit

protocol AddContactCellDelegate {
    func deleteCell(at name: String)
}

class AddContactTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!

    // MARK: Class instances
    
    /// Add contact cell delegate
    public var delegate: AddContactCellDelegate?
    
    /// Store contact full name
    public var name: String? {
        didSet {
            nameLabel.text = self.name
        }

    }
    
    // MARK: - Actions

    @IBAction func addButtonTapped(_ sender: UIButton) {
        if let name = name {
            delegate?.deleteCell(at: name)
        }
    }
}
