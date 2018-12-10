//
//  MainNavigationController.swift
//  Tripit
//
//  Created by Raz Vaknin on 29 Kislev 5779.
//  Copyright © 5779 razop. All rights reserved.
//

import Foundation
import UIKit


class MainNavigationController : UINavigationController
{
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    override func viewDidLoad(){
        super.viewDidLoad()
}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.performSegue(withIdentifier: "loginView",sender:self)
    }
    @IBAction func registerButtonTapped(_ sender: Any) {
        
        let username = usernameTextField.text
        let userPassword = userPasswordTextField.text
        let userRepeatPassword = repeatPasswordTextField.text
        
        
        //display alert messages
        func displayMyAlertMessage(userMessage: String)
        {
            var myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertController.Style.alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            myAlert.addAction(okAction)
            
            self.present(myAlert,animated: true, completion:nil)
        }
        
        
        //check for empty fields
        if((username?.isEmpty)! || (userRepeatPassword?.isEmpty)! || (userPassword?.isEmpty)!)
        {
            //display alert
            displayMyAlertMessage(userMessage: "All fields are required")
            return
            
        }
        //check if password match
        if(userPassword != userRepeatPassword)
        {
            //display alert message
            displayMyAlertMessage(userMessage: "Passwords do not match")
            return
        }
        
      
       
        //store data
        
      
        
    
    }
}
