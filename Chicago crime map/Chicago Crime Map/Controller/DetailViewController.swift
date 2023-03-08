//
//  DetailViewController.swift
//  Chicago crime map
//
//  Created by Ryoya Hashimoto on 2/18/23.
//

import UIKit

// To show the detail information of each crime incident
class DetailViewController: UIViewController {

    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var domesticLabel: UILabel!
    @IBOutlet var arrestLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Settings for Navigation Bar
        navigationItem.title = "Crime Description"
        self.navigationController?.navigationBar.titleTextAttributes = [
            //NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.heavy)
        ]
        navigationController?.navigationBar.backgroundColor = .systemOrange
        
        // Settings for each label
        typeLabel.text = DataManager.sharedInstance.crimeAnnotation.crimeType
        descriptionLabel.text = DataManager.sharedInstance.crimeAnnotation.crimeDescription
        dateLabel.text = DataManager.sharedInstance.crimeAnnotation.date
        addressLabel.text = DataManager.sharedInstance.crimeAnnotation.address
        locationLabel.text = DataManager.sharedInstance.crimeAnnotation.locationDescription
        domesticLabel.text = DataManager.sharedInstance.crimeAnnotation.domestic
        arrestLabel.text = DataManager.sharedInstance.crimeAnnotation.arrest
    }

    @IBAction func doneAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
