//
//  ProfileViewController.swift
//  Tripit
//
//  Created by admin on 04/01/2019.
//  Copyright © 2019 razop. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
 
    
    @IBAction func TappedOnBackToMainController(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }    
}
