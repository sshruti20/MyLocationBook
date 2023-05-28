//
//  PlaceModel.swift
//  my-foursquare-clone
//
//  Created by Shruti S on 21/05/23.
//

import Foundation
import UIKit

class PlaceModel {
    
    static let sharedInstance = PlaceModel()
    
    var placeName = ""
    var placeType = ""
    var placeAtmosphere = ""
    var placeImage = UIImage()
 
    var placeLatitude = ""
    var placeLongitude = ""
    
    private init() {}
    
}
