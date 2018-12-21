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
    }
       
    @IBAction func onLoginTapped(_ sender: Any) {
        let email = UsernameText.text
        let password = PasswordText.text
        
        if(email == "" || password == "" ){
            present(Consts.General.getCancelAlertController(title: "Login", messgae: "Please enter Email or Password"), animated: true)
        }
        else{
            
            Model.instance.signIn(email!, password!, { (res) in
                
                if(res) {
                    self.loginSuccessfull();
                } else {
                    self.present(Consts.General.getCancelAlertController(title: "Login", messgae: "Failed while trying to Login. Please try again"), animated: true)
                }
            })
            
        }
    }
  
    func loginSuccessfull(){
        //bundle is the place where all of the app's assets and source codes lived in before they compiled
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        //Getting the navigation controller
        guard let mainNavigationVC = mainStoryboard.instantiateViewController(withIdentifier: "MainNavigationController") as? MainNavigationController else {
            return
        }
        //Navigate to the main view
        present(mainNavigationVC, animated: true, completion: nil)    }
    
    
  /*  private func navigateToMainInterface(){
        //bundle is the place where all of the app's assets and source codes lived in before they compiled
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        //Getting the navigation controller
        guard let mainNavigationVC = mainStoryboard.instantiateViewController(withIdentifier: "MainNavigationController") as? MainNavigationController else {
            return
        }
        //Navigate to the main view
        present(mainNavigationVC, animated: true, completion: nil)
    }
       */
}
