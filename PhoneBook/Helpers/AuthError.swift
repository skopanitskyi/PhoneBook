//
//  AuthError.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 07.09.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import Foundation

enum AuthError {
    case notFilled
    case cancelled
    case failedToCreateUser
    case failedToLogin
    case failedToSignIn
    case failedToAddData
    case failedToSignOut
    case failedToUpdateData
    case unknownError
}

extension AuthError: LocalizedError {
   public var errorDescription: String? {
        switch self {
        case .notFilled:
            return "AuthenticationErrors.FieldsNotFilled".localized
        case .cancelled:
            return "AuthenticationErrors.Canceled".localized
        case .failedToCreateUser:
            return "AuthenticationErrors.FailedToCreateUser".localized
        case .failedToLogin:
            return "AuthenticationErrors.FailedToLogin".localized
        case .failedToSignIn:
            return "AuthenticationErrors.FailedToSignIn".localized
        case .failedToAddData:
            return "AuthenticationErrors.FailedToSaveData".localized
        case .failedToSignOut:
            return "AuthenticationErrors.FailedToSignOut".localized
        case .failedToUpdateData:
            return "AuthenticationErrors.FailedToUpdateData".localized
        case .unknownError:
            return "AuthenticationErrors.UnknownError".localized
        }
    }
}
