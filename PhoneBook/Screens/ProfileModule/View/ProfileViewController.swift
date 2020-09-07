//
//  ProfileViewController.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 24.08.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit
import MapKit

class ProfileViewController: UITableViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    public var viewModel: ProfileViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logOutTapped(_ sender: Any) {
        
    }
}
