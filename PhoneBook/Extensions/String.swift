//
//  String.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 08.08.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import Foundation

extension String {
    
    func removeWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
