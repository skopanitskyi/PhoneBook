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
    case unknownError
}

extension AuthError: LocalizedError {
   public var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Заполните все поля", comment: "")
        case .cancelled:
            return NSLocalizedString("Авторизация была отменена", comment: "")
        case .failedToCreateUser:
            return NSLocalizedString("Не удалось создать пользователя", comment: "")
        case .failedToLogin:
            return NSLocalizedString("Не удалось авторизоваться", comment: "")
        case .failedToSignIn:
            return NSLocalizedString("Не удалсь зарегистрировать пользователя", comment: "")
        case .failedToAddData:
            return NSLocalizedString("Не удалось сохранить данные", comment: "")
        case .unknownError:
            return NSLocalizedString("Неизвестная ошибка", comment: "")
        }
    }
}
