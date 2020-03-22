//
//  AddKidViewController.swift
//  Good Kids v3
//
//  Created by Aleksandr Ozhogin on 21/3/20.
//  Copyright © 2020 Aleksandr Ozhogin. All rights reserved.
//

import UIKit
import Firebase

class AddKidViewController: UIViewController {

    var user: User!
    var newKidUser = User()
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBAction func segmentChanged(_ sender: Any) {
        newKidUser.isBoy  = !newKidUser.isBoy
        print("newKidUser.isBoy property is now: \(newKidUser.isBoy)")
    }
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        if nameTextField.text != "" && loginTextField.text != "" && passwordTextField.text != "" && String(passwordTextField.text!).count > 5 {
                if let newKidUserLogin = loginTextField.text {
                    let email = "\(newKidUserLogin.lowercased())@mydomain.com"
                    print(email)
                    Auth.auth().createUser(withEmail: email, password:  passwordTextField.text!) { (user, error) in
                        if error != nil {
                            let message = error?.localizedDescription
                            if message!.contains("The email address is already in use by another account") {
                                self.showAlert(alertMessage: "The user already exists")
                            } else {
                                self.showAlert(alertMessage: "New error. check console for details")
                                print("New error: \(String(describing: error))")
                            }
                        } else {
                            print("User \(newKidUserLogin) created successfully")
                            do {
                                try Auth.auth().signOut()
                                if let currentUser = self.user?.login {
                                    if let currentPassword = UserDefaults.standard.object(forKey: "password") as? String {
                                        Auth.auth().signIn(withEmail: "\(currentUser)@mydomain.com", password: currentPassword) { (user, error) in
                                            if error != nil {
                                                if let message = error?.localizedDescription {
                                                    print("error logging back in: \(message)")
                                                }
                                            } else {
                                                
                                                self.newKidUser.familyName = self.user.familyName
                                                self.newKidUser.username = self.nameTextField.text!
                                                self.newKidUser.login = self.loginTextField.text!
                                                self.newKidUser.score = 0
                                                self.newKidUser.isAdult = false
                                                self.newKidUser.updateDB()
//                                                let segmentIndex = self.segmentControl.selectedSegmentIndex
//                                                if segmentIndex == 0 {
//                                                    self.newKidUser.isBoy = true
//                                                } else {
//                                                    self.newKidUser.isBoy = false
//                                                }
                                                
                                                if let menuVC = self.navigationController?.viewControllers[1] {
                                                    self.navigationController?.popToViewController(menuVC, animated: true)
                                                } else {
                                                    print("Could not pop Main Menu ViewController")
                                                }
                                            }
                                        }
                                    }
                                }
                            } catch {
                                self.showAlert(alertMessage: "could not sign out")
                            }
                        }
                }
            }
        } else {
            showAlert(alertMessage: "Fill all the fields and password should be more than 6 digits, you moron!")
        }
    }
            
    override func viewDidLoad() {
        super.viewDidLoad()
     
        newKidUser.isBoy = true
    }
    
    func showAlert(alertMessage: String) {
           let alert = UIAlertController(title: alertMessage, message: nil, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           
           self.present(alert, animated: true)
       }
}
