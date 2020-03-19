//
//  NewUserViewController.swift
//  Good Kids v3
//
//  Created by Aleksandr Ozhogin on 11/3/20.
//  Copyright © 2020 Aleksandr Ozhogin. All rights reserved.
//

import UIKit
import Firebase

class NewUserViewController: UIViewController {

    var newUser = User()
    var email: String = ""
    let defaults = UserDefaults.standard
    let db = Firestore.firestore()
    
    @IBOutlet weak var familyTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    

    
    @IBAction func submitButtonPressed(_ sender: Any) {
        //checking new option
        if loginTextField.text != "" && familyTextField.text != "" && nameTextField.text != "" && passwordTextField.text != "" && String(passwordTextField.text!).count > 5 {
                newUser.login = loginTextField.text!
                newUser.username = nameTextField.text!
                newUser.familyName = familyTextField.text!
                
                create(user: newUser, password: passwordTextField.text!)
            
        } else {
            showAlert(alertMessage: "Fill the form rightly, you moron! (all fields should not be blank, password > 6 digits")
        }
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMainMenu" {
            let destinationVC = segue.destination as! MainMenuViewController
            destinationVC.user = newUser
        }
    }
    
    func create(user: User, password: String) {
//        familyName: String, name: String, login: String, password: String) {
    
        let docRef = db.collection("famlies").document(user.familyName)
        docRef.getDocument { (document, error) in
            if let document = document {
                if document.exists{
                    print("family exists")
                    self.showAlert(alertMessage: "Family with this name already exists. Please pick another name")
                } else {
                    print("family does not exist, creating new user")
                    let email = "\(user.login)@domain.com"
                     Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                         if error != nil {
                             let message = error?.localizedDescription
                             if message!.contains("The email address is already in use by another account") {
                                     self.showAlert(alertMessage: "Error: The user already exists")
                         
                                 } else if message!.contains("A server with the specified hostname could not be found") {
                                     self.showAlert(alertMessage: "Error: Check your internet connection")
                                      
                                 } else if message!.contains("An SSL error has occurred and a secure connection to the server cannot be made") {
                                     self.showAlert(alertMessage: "Error: An SSL error has occurred and a secure connection to the server cannot be made")

                                 } else {
                                     self.showAlert(alertMessage: "Error: \(String(describing: error))")
                                 }
                                  
                             } else {
                            print("User \(self.newUser.login) created successfully")
                                self.newUser.addToDB()
                                print("ready for segue")
                                self.performSegue(withIdentifier: "toMainMenu", sender: self)
                             }
                                   
                           }
                    
                }
            }
        }
    }
//            newUser.addToDB()
//        } else {
//            if let createError = newUser.currentError {
//                showAlert(alertMessage: createError)
//            }
//        }
//        while newUser.addedToDB == false {
//            sleep(1)
//        }
        
//                let email = "\(login)@mydomain.com"
//
//                Auth.auth().addStateDidChangeListener { (auth, user) in
//
//                    if user != nil {
//                        if let userAuthEmail = user?.email {
//                            if userAuthEmail == self.email {
//                                print("new user signed in: \(userAuthEmail). Create function completed")
//
//                            } else {
//                                print ("\(userAuthEmail) state did change")
//
//                                self.performSegue(withIdentifier: "toMainMenu", sender: self)
//                            }
//                        }
//                    }
//                }
//
//                Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
//                    if error != nil {
//                        let myError = String(error!.localizedDescription)
//                        print("error occurred while creating a new user: \(myError)")
//                        self.showAlert(alertMessage: myError)
//
//                    } else {
//                        print("user: \(user?.credential) has been created successfully")
//
//                    }
//        }
//        return newUser
            
    func showAlert(alertMessage: String) {
        let alert = UIAlertController(title: alertMessage, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
        
}


