//
//  PlacesFilterDelegate.swift
//  Chicago crime map
//
//  Created by Ryoya Hashimoto on 2/23/23.
//

import Foundation

protocol PlacesFilterDelegate: AnyObject {
    func changeFilter(crimeType: String, date: String)
}
