//
//  Location.swift
//  BucketList
//
//  Created by Arthur Sh on 23.12.2022.
//

import Foundation
import CoreLocation

struct Location: Identifiable, Codable, Equatable {
    var id: UUID
    var name: String
    var description: String
    let latitude: Double
    let longitude: Double
    
    //MARK: The CL in CLLocationCoordinate2D stands for Core Location.
    var coordinate: CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static let example = Location(id: UUID(), name: "Jurassic park", description: "That's where all the ancient creatures are living", latitude: 50, longitude: -13)
    
    static func ==(lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}
