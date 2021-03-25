//
//  PasswordVC.swift
//  Notes
//
//  Created by Mohit Gupta on 25/03/21.
//

import UIKit
import SwiftKeychainWrapper
class PasswordVC: UIViewController {

    //Connecting two input text fields outlet
    @IBOutlet weak var passText: UITextField!
    @IBOutlet weak var confirmPassText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    //Function for Action performed when user inputs password and taps Confirm
    @IBAction func confirmBtnTapped(_ sender: Any) {
        //Disappear Keyboard when user taps anywhere other than keyboard or textfield
        passText.resignFirstResponder()
        confirmPassText.resignFirstResponder()
        
        if let password = passText.text , let confirm = confirmPassText.text{
        
        //Checking if both passwords match in both textfields
        if password == confirm{
            //Using keychain to set password by adding string value to keychain
            KeychainWrapper.standard.set(password, forKey: "password")
            
            print("saved")
            
            //code for displaying password page only once
            UserDefaults.standard.set(true, forKey: "didSeePass")
            self.performSegue(withIdentifier: "present", sender: self)
            
        }
        //Condition for passwords not matching of both textfields
        else{
            commonAlert(message: "Password and Confirm Password are not same")
        }
        }
        //Condiftion if no details are filled in both textfields
        else{
            commonAlert(message: "Please Fill the complete details")
        }
        
    }
    
    //Function for disappearing keyboard when tapped outside
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
