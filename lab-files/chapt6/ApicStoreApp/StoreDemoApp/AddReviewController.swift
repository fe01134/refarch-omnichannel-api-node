//
//  AddReviewController.swift
//  StoreDemoApp
//
//  Created by Chris Tchoukaleff on 6/2/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

class AddReviewController: UIViewController, UINavigationControllerDelegate {
    
    var review:Review!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(review.itemID)
        
    }
}
