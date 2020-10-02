//
//  AuthResult.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 07.09.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import Foundation

/// Authorization result
enum AuthResult {
    case success
    case failure(AuthError)
}

enum FacebookAuth {
    case success(Bool?, String?)
    case failure(AuthError)
}

enum ContactsData {
    case success([Contact])
    case failure(AuthError)
}

/// User data retrieval result
enum UserData {
    case success(User)
    case failure(AuthError)
}
