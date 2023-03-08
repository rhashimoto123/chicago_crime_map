//
//  DataManager.swift
//  Chicago crime map
//
//  Created by Ryoya Hashimoto on 2/18/23.
//

import Foundation

public class DataManager {
    
    // Annotation: https://stackoverflow.com/questions/25179668/how-to-save-and-read-array-of-array-in-nsuserdefaults-in-swift
    let defaults = UserDefaults.standard
    
    // MARK: - Singleton Stuff
    public static let sharedInstance = DataManager()
    
    private(set) var crimes: [Place]
    private(set) var filteredCrimes: [Place]
    private(set) var crimeTypeFilter: String
    private(set) var dateFilter: String
    private(set) var crimeAnnotation: Place
    private(set) var selectedRow: Int
    
    private init() {
        crimes = []
        filteredCrimes = []
        crimeTypeFilter = "ALL"
        dateFilter = "All"
        crimeAnnotation = Place()
        selectedRow = 0
        
        // Store an NSDate on first launch
        defaults.register(defaults: ["Initial Launch": NSDate()])
        defaults.register(defaults: ["Login Count": Int()])
    }
    
    
    func refreshCrimeData(_ crimes: [Place]) {
        self.crimes = crimes
        self.filteredCrimes = crimes
    }
    
    func updateFilteredCrimes(_ filteredCrimes: [Place]) {
        self.filteredCrimes = filteredCrimes
    }
    
    func updateCrimeType(crimeType: String? = nil) {
        if let crimeType = crimeType {
            self.crimeTypeFilter = crimeType
        }
    }
    
    func updateDate(dateLimit: String? = nil) {
        if let dateLimit = dateLimit {
            self.dateFilter = dateLimit
        }
    }
    
    func updateCrimeAnnotation(crimeAnnotation: Place? = nil) {
        if let crimeAnnotation = crimeAnnotation {
            self.crimeAnnotation = crimeAnnotation
        }
    }
    
    func updateSelectedRow(selectedRow: Int? = nil) {
        if let selectedRow = selectedRow {
            self.selectedRow = selectedRow
        }
    }
    
}
