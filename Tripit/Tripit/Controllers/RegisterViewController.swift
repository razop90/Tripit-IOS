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
        let email = emailField.text
        let password = passwordFiled.text
        let repassword = repasswordFiled.text
        
        if(email == "" || password == "" || password != repassword){
            if(password != repassword){
                present(Consts.General.getCancelAlertController(title: "Registration", messgae: "Please enter same passwords"), animated: true)
            }
            else{
                present(Consts.General.getCancelAlertController(title: "Registration", messgae: "Please enter Email or Password"), animated: true)
            }
        }
        else{
            
            Model.instance.signUp(email!, password!, { (res) in
                
                if(res) {
                    self.performSegue(withIdentifier: "registerSugue", sender: nil)
                } else {
                    self.present(Consts.General.getCancelAlertController(title: "Registration", messgae: "Failed while trying to register. Please try again"), animated: true)
                }
            })
        }
    }
}



/*  guard
 let email = emailField.text,
 email != "",
 
 let password = passwordFiled.text,
 password != "",
 
 let repassword = repasswordFiled.text,
 repassword != "",
 
 password == repassword
 
 else {
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
 */
