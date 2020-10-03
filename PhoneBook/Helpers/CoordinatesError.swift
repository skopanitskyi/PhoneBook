//
//  CoordinatesError.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 03.10.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import Foundation

/// Errors that occur when working with maps
enum CoordinateError {
    case failedToGetCoordinates
    case failedToGetRoute
}

/// Description of the errors encountered
extension CoordinateError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .failedToGetCoordinates:
            return "CoordinatesError.FailedToGetCoordinates".localized
        case .failedToGetRoute:
            return "CoordinatesError.FailedToGetRoute".localized
        }
    }
}
