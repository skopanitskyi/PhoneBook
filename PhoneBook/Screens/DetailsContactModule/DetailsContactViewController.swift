//
//  DetailsContactViewController.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 21.09.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit

class DetailsContactViewController: UIViewController {
    
    public var viewModel: DetailsContactViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        viewModel?.updateFavoriteStatus()
    }
}
