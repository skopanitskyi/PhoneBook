//
//  MapService.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 28.09.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import Foundation
import MapKit

class MapService {
    
    
    public func getCoordinates(with adress: String, completion: @escaping ((CLLocationCoordinate2D?) -> Void)) {
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(adress) { (placemark, error) in
            if let error = error {
                completion(nil)
                print(error.localizedDescription)
                return
            }
            completion(placemark?.first?.location?.coordinate)
        }
    }
}
