//
//  PlaceMarkerView.swift
//  Chicago crime map
//
//  Created by Ryoya Hashimoto on 2/18/23.
//

import UIKit
import MapKit

class PlaceMarkerView: MKMarkerAnnotationView {
    
    override var annotation: MKAnnotation? {
          willSet {
            clusteringIdentifier = "Place"
            displayPriority = .defaultLow
            markerTintColor = .systemBlue
            glyphImage = UIImage(systemName: "pin.fill")
            }
      }
    
}
