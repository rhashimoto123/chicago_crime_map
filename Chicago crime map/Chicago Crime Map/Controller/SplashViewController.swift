//
//  SplashViewController.swift
//  Chicago Crime Map
//
//  Created by Ryoya Hashimoto on 3/3/23.
//

import UIKit


// Display Splash Screen for the first login
class SplashViewController: UIViewController {

    //
    // MARK: - Properties
    //
    
    @IBOutlet var continueButton: UIButton!
    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    


}
