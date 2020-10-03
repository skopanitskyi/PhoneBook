//
//  MapService.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 28.09.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import Foundation
import MapKit

class MapService: Service {
    
    // MARK: - Class methods
    
    
    /// Returns the coordinates of a contact by his address
    /// - Parameters:
    ///   - address: Address of the contact
    ///   - completion: Return coordinate
    public func getCoordinates(with address: String, completion: @escaping ((CoordinateResult) -> Void)) {
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address) { (placemark, error) in
            guard let coordinates = placemark?.first?.location?.coordinate else {
                completion(.failure(.failedToGetCoordinates))
                return
            }
            completion(.success(coordinates))
        }
    }
    
    /// Build a route from the user to the selected contact
    /// - Parameters:
    ///   - userCoordinate: User coordinate
    ///   - address: Contact address
    ///   - name: Contact name
    ///   - completion: Return route and point annotation
    public func getRoute(userCoordinate: CLLocationCoordinate2D,
                         contactCoordinate: CLLocationCoordinate2D,
                         completion: @escaping ((RouteResult) -> Void)) {
        
        let request = getRequest(startCoordinate: userCoordinate,
                                 endCoordinate: contactCoordinate,
                                 transport: .automobile)
        
        calculateRoute(request: request) { completion($0) }
    }
    
    /// Calculate a route from user to contact
    /// - Parameters:
    ///   - request: Request for the calculate the route
    ///   - completion: Return the route
    private func calculateRoute(request: MKDirections.Request, completion: @escaping ((RouteResult) -> Void)) {
        let direction = MKDirections(request: request)
        direction.calculate { (result, error) in
            guard let route = result?.routes.first else {
                completion(.failure(.failedToGetRoute))
                return
            }
            completion(.success(route))
        }
    }
    
    /// Return a request for calculate route
    /// - Parameters:
    ///   - startCoordinate: User coordinate
    ///   - endCoordinate: Contact coordinate
    ///   - transport: Transport by which the user will get to the contact
    private func getRequest(startCoordinate: CLLocationCoordinate2D,
                            endCoordinate: CLLocationCoordinate2D,
                            transport: MKDirectionsTransportType) -> MKDirections.Request {
        let start = MKPlacemark(coordinate: startCoordinate)
        let end = MKPlacemark(coordinate: endCoordinate)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: start)
        request.destination = MKMapItem(placemark: end)
        request.transportType = transport
        return request
    }
    
    /// Returns the annotation for the contact to be added to the map
    /// - Parameters:
    ///   - coordinate: Contact coordinate
    ///   - name: Contact name
    public func getAnotation(coordinate: CLLocationCoordinate2D, name: String) -> MKPointAnnotation {
        let anotation = MKPointAnnotation()
        anotation.coordinate = coordinate
        anotation.title = name
        return anotation
    }
}
