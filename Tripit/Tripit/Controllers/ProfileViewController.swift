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
        self.gotoMainview();
    }

    func gotoMainview(){
        //bundle is the place where all of the app's assets and source codes lived in before they compiled
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        //Getting the navigation controller
        guard let mainNavigationVC = mainStoryboard.instantiateViewController(withIdentifier: "MainNavigationController") as? MainNavigationController else {
            return
        }
        //Navigate to the main view
        present(mainNavigationVC, animated: true, completion: nil)
    }
}
