//
//  PasswordVC.swift
//  Notes
//
//  Created by Mohit Gupta on 25/03/21.
//

import UIKit
import SwiftKeychainWrapper
class PasswordVC: UIViewController {

    
    @IBOutlet weak var passText: UITextField!
    @IBOutlet weak var confirmPassText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    

    @IBAction func confirmBtnTapped(_ sender: Any) {
        passText.resignFirstResponder()
        confirmPassText.resignFirstResponder()
        if let password = passText.text , let confirm = confirmPassText.text{
        
        if password == confirm{
            KeychainWrapper.standard.set(password, forKey: "password")
            print("saved")
            UserDefaults.standard.set(true, forKey: "didSeePass")
            self.performSegue(withIdentifier: "present", sender: self)
            
        }
        else{
            commonAlert(message: "Password and Confirm Password are not same")
        }
        }
        else{
            commonAlert(message: "Please Fill the complete details")
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        passText.resignFirstResponder()
        confirmPassText.resignFirstResponder()
    }
    
    
    func commonAlert(message : String) {
        let alertController = UIAlertController(title: "Alert", message:
               message, preferredStyle: .alert)
           alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
           self.present(alertController, animated: true, completion: nil)
    }

}
