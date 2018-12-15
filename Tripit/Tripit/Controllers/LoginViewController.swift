//
//  LoginViewController.swift
//  Tripit
//
//  Created by Raz Vaknin on 29 Kislev 5779.
//  Copyright © 5779 razop. All rights reserved.
//

import Foundation
import UIKit
//import Firebase

class LoginViewController : UIViewController {
    
    @IBOutlet weak var UsernameText: UITextField!
    @IBOutlet weak var PasswordText: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //FirebaseApp.configure()
        
        //Test:
        //let ref = Database.database().reference()
        //ref.child("test33").setValue("te55544555")
    }
       
    @IBAction func OnLoginSubmit(_ sender: Any) {
        //Add login validation before the navigation function below
          navigateToMainInterface()
    }
    
    
    private func navigateToMainInterface(){
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
