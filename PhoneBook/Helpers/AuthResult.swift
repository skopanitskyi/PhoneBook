//
//  AuthResult.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 07.09.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import Foundation

enum AuthResult {
    case success
    case failure(AuthError)
}

enum UserSavedData {
    case success([Contact])
    case failure(AuthError)}
