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
    
    @IBOutlet weak var nameLabel: UILabel!

    public var name: String? {
        didSet {
            nameLabel.text = self.name
        }
    }
    
    public var delegate: AddContactCellDelegate?

    @IBAction func addButtonTapped(_ sender: UIButton) {
        if let name = name {
            delegate?.deleteCell(at: name)
        }
    }
}
