//
//  FiltersViewController.swift
//  Chicago crime map
//
//  Created by Ryoya Hashimoto on 2/18/23.
//

import UIKit

// To filter crime incidents by crime types and time period
class FiltersViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var crimeTypeSelecction: UIPickerView!
    @IBOutlet var dateSelection: UISegmentedControl!
    
    weak var delegate: PlacesFilterDelegate?
    
    let crimeTypeList = ["ALL", "THEFT", "BATTERY", "CRIMINAL DAMAGE", "MOTOR VEHICLE THEFT", "ASSAULT", "DECEPTIVE PRACTICE", "OTHER OFFENSE", "ROBBERY", "BURGLARY", "CRIMINAL TRESPASS", "NARCOTICS","OFFENSE INVOLVING CHILDREN","CRIMINAL SEXUAL ASSAULT","SEX OFFENSE","HOMICIDE","STALKING"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        crimeTypeSelecction.delegate = self
        crimeTypeSelecction.dataSource = self
        crimeTypeSelecction.selectRow(DataManager.sharedInstance.selectedRow, inComponent: 0, animated: false)

    }
    
    // The number of columns of UIPickerView
    func numberOfComponents(in crimeTypeSelecction: UIPickerView) -> Int {
        return 1
    }
    // The number of rows of UIPickerView
    func pickerView(_ crimeTypeSelecction: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return crimeTypeList.count
    }
    // First display of UIPickerView
    func pickerView(_ crimeTypeSelecction: UIPickerView,titleForRow row: Int, forComponent component: Int) -> String? {
            return crimeTypeList[row]
    }
    // Actions when the row of UIPickerView is tapped
    func pickerView(_ crimeTypeSelecction: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("DEBUG ----> The Crime Type picker is changed")
        DataManager.sharedInstance.updateCrimeType(crimeType: crimeTypeList[row])
        DataManager.sharedInstance.updateSelectedRow(selectedRow: row)
        }
    
    @IBAction func dateChanged(_ sender: UISegmentedControl) {
        print("DEBUG ----> The Date picker is changed")
        
        guard let newDate = DateType(rawValue: dateSelection.selectedSegmentIndex) else {
            return
        }
        
        let index = dateSelection.selectedSegmentIndex
        var selectedDateFilter: String
        if index == 0 {
            selectedDateFilter = "All"
        } else if index == 1 {
            selectedDateFilter = "1 week"
        } else if index == 2 {
            selectedDateFilter = "2 weeks"
        } else {
            selectedDateFilter = "Month"
        }
        
        DataManager.sharedInstance.updateDate(dateLimit: selectedDateFilter)
    }
    
    @IBAction func applyFilterButton(_ sender: Any) {
        print("DEBUG ----> The Apply Filter button is tapped")
        delegate?.changeFilter(crimeType: DataManager.sharedInstance.crimeTypeFilter, date: DataManager.sharedInstance.dateFilter)
    }
    

}
