//
//  RegisterViewController.swift
//  Tripit
//
//  Created by admin on 15/12/2018.
//  Copyright © 2018 razop. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

   
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordFiled: UITextField!
    
    @IBOutlet weak var repasswordFiled: UITextField!
    
    
    @IBAction func onRegisterTapped(_ sender: Any) {
        guard
            let email = emailField.text,
            email != "",
            
            let password = passwordFiled.text,
            password != ""
            
            else{
                present(Consts.General.getCancelAlertController(title: "Registration", messgae: "Please enter Email or Password"), animated: true)
                return
        }
        
        Model.instance.signUp(email, password, { (res) in
            
            if(res) {
                self.performSegue(withIdentifier: "registerSugue", sender: nil)
            } else {
                self.present(Consts.General.getCancelAlertController(title: "Registration", messgae: "Failed while trying to register. Please try again"), animated: true)
            }
        })

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
