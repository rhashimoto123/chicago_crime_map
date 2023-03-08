//
//  Place.swift
//  Chicago crime map
//
//  Created by Ryoya Hashimoto on 2/18/23.
//

import Foundation

import MapKit

class Place: MKPointAnnotation {
    
    var id: String?
    
    var date: String?
    
    // Description of the crime
    var crimeType: String?
    var crimeDescription: String?
    var locationDescription: String?
    
    var arrest: String?
    var address: String?
    var domestic: String?
    
    var latitude: String?
    var longitude: String?
    
    // Return date of date type
    var date_DATETYPE: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss a"
        dateFormatter.locale = Locale(identifier: "en_US")
        let dateType = dateFormatter.date(from: date ?? "02/10/2023 11:59:00 PM") ?? Date()
        return dateType
    }
    
}
