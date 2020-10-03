//
//  MapResults.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 03.10.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import MapKit

/// Result of obtaining contact coordinates
enum CoordinateResult {
    case success(CLLocationCoordinate2D)
    case failure(CoordinateError)
}

/// The result of getting the route between the contact and the user
enum RouteResult {
    case success(MKRoute)
    case failure(CoordinateError)
}
