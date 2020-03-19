//
//  ViewController.swift
//  Good Kids v3
//
//  Created by Aleksandr Ozhogin on 11/3/20.
//  Copyright © 2020 Aleksandr Ozhogin. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

//    var modelController = ModelController()
    let defaults = UserDefaults.standard
    var db: Firestore!
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func loginButtonClicked(_ sender: Any) {
        if String(loginTextField.text!).count > 0 && String(passwordTextField.text!).count > 0 {
            login(username: loginTextField.text!, password: passwordTextField.text!)
        }
    }
    
    @IBAction func newAccountButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "toCreateParent", sender: Any.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
//        view.addGestureRecognizer(tap)
//
//        if let lastLoginAttempt = UserDefaults.standard.object(forKey: "lastLoginSucceeded") as? String {
//            if lastLoginAttempt == "true" {
//                let user = UserDefaults.standard.object(forKey: "user") as? String
//                let password = UserDefaults.standard.object(forKey: "password") as? String
//
//            }
//
//            if loginTextField.text != "" && passwordTextField.text != "" {
//                print("both username & password populated from defaults")
//
//
//                if let lastLogin = UserDefaults.standard.object(forKey: "lastLoginSucceeded") as? String {
//                    print(lastLogin)
//                    if lastLogin == "true" {
//                        print("Condition met: last login successful = true")
//
//
//                        preLogin()
//
//                } else {print("lastlogin is false")}
//
//                }
//            }
        }
    
//    func preLogin() {
//        if loginTextField.text == "" || passwordTextField.text == "" {
//
//
//                 } else if passwordTextField.text!.count < 6 {
//                    print("password should be 6 or more characrets long")
//                 } else {
//                    print("Auth should be triggered")
//
//                    let user = Auth.auth().currentUser;
//
//                    if user != nil {
//                        print("another user is logged in")
//                        try! Auth.auth().signOut()
//
//
//                        login()
//                        // User is signed in.
//                      } else {
//
//                        login()
//                      }
//
//                        }
//
//                   }

//        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//            if segue.identifier == "toMainMenu" {
//
//
//
//                let destinationVC = segue.destination as! MainMenuViewController
//                destinationVC.modelController = modelController
//    //            if let textToPass = usernameTextField.text {
//    //                destinationVC.username = textToPass
//                } else if segue.identifier == "toCreateParent" {
//                let destinationVC = segue.destination as! NewUserViewController
//                if let username = loginTextField.text {
//
//                    modelController.currentUser.username = username
//                }
//                    destinationVC.modelController = modelController
//
////                }
////                if let textToPass = passwordTextField.text {
////                    destinationVC.password = textToPass
////                }
//            }
//        }
    
        func login(username: String, password: String) {
            
            let email = "\(username)@mydomain.com"
//            let usersRef = db.collection("users")
            
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if error != nil {
                    let message = error?.localizedDescription
                    if message!.contains("There is no user record corresponding to this identifier") {
                        print("This user does not exist. Click 'New User' to create")
                        
                    } else if message!.contains("The password is invalid or the user does not have a password") {
                        print("Password incorrect")
            
                    } else {
                        print(error?.localizedDescription as Any)
                    }
                                            
                } else {
                    print("Login was successful")

//                    self.modelController.user.username = username
//                    self.db.collection("users").whereField("username", isEqualTo: username).getDocuments() { (QuerySnapshot, err) in
//                        if let err = err {
//                            print("Error getting user data: \(err)")
//                        } else {
//                            for document in QuerySnapshot!.documents {
//                                print("\(document.documentID) => \(document.data())")
//                            }
//                        }
                    }
                                                             
                    UserDefaults.standard.set("true", forKey: "lastLoginSucceeded")
                    UserDefaults.standard.set(self.loginTextField.text, forKey: "user")
                    UserDefaults.standard.set(self.passwordTextField.text, forKey: "password")
                    print("breakpoint")
//                                            self.performSegue(withIdentifier: "toMainMenu", sender: self)
                }}
            }
        
    


