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
    
    var db: Firestore!
    let defaults = UserDefaults.standard
    var currentUser = User()
    var cameFromMainMenu = false
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        loggedIn = false
//        dbDataLoaded = false
//    }
    
    var loggedIn = false {
        didSet {
            print("loggedIn property has changed from \(oldValue) to \(loggedIn) ")
            if loginTextField.text != "" {
                if let login = loginTextField.text {
                    currentUser.login = login
                }
            } else {
                if let login = UserDefaults.standard.object(forKey: "user") as? String {
                    currentUser.login = login
                }
            }
            db = Firestore.firestore()
            let settings = FirestoreSettings()
            Firestore.firestore().settings = settings
            let Ref = db.collection("users").document("\(currentUser.login)")
                                          
            Ref.getDocument { (document, error) in
                if let document = document, document.exists {
                    _ = document.data().map(String.init(describing:)) ?? "nil"
                    let family = document.get("familyName") as! String
                    let isAdult = document.get("isAdult") as! Bool
                    let name = document.get("name") as! String
                    let score = document.get("score") as! Int
                    let isBoy = document.get("isBoy") as! Bool
                    self.currentUser.score = score
                    self.currentUser.isBoy = isBoy
                    self.currentUser.username = name
                    print("Setting currentUser.username = \(name)")
                    self.currentUser.isAdult = isAdult
                    print("Setting currentUser.isAdult = \(isAdult)")
                    self.currentUser.familyName = family
                    print("Setting currentUser.familyName = \(family)")
                    print("currentUser.login is \(self.currentUser.login)")
                    self.dbDataLoaded = true
                            
                } else {
                    print("Document does not exist")
                }
                            
            }
        }
    }
    
    var dbDataLoaded = false {
        didSet {
            if dbDataLoaded {
                print("dbDataLoaded property changed from \(oldValue) to \(dbDataLoaded)")
                performSegue(withIdentifier: "toMainMenu", sender: self)
            }
        }
    }

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func loginButtonClicked(_ sender: Any) {
       
        if String(loginTextField.text!).count > 0 && String(passwordTextField.text!).count > 5 {
            login(username: loginTextField.text!, password: passwordTextField.text!)
        }
    }
    
    @IBAction func newAccountButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "toCreateParent", sender: Any.self)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    
        if cameFromMainMenu == false {
            if let lastLoginAttempt = UserDefaults.standard.object(forKey: "lastLoginSucceeded") as? String {
                if lastLoginAttempt == "true" {
                    
                    if let user = UserDefaults.standard.object(forKey: "user") as? String {
                        if let password = UserDefaults.standard.object(forKey: "password") as? String {
                            print("found valid credentials from previous login: \(user):\(password)")
                            if user != "" && password != "" {
                                login(username: user, password: password)
                            }
                        }
                    }
                }
            }
        } else {
            UserDefaults.standard.set("false", forKey: "lastLoginSucceeded")
            UserDefaults.standard.set(self.loginTextField.text!, forKey: "")
            UserDefaults.standard.set(self.passwordTextField.text!, forKey: "")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMainMenu" {
            let destinationVC = segue.destination as! MainMenuViewController
            print("Preparing segue: passing user to mainmenuVC with params name:\(currentUser.username), login: \(currentUser.login), family: \(currentUser.familyName), isAdult: \(currentUser.isAdult), score: \(currentUser.score), isBoy: \(currentUser.isBoy)")
            destinationVC.user = currentUser
        }
    }
    
    func login(username: String, password: String) {
            
            let email = "\(username)@mydomain.com"

            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if error != nil {
                    let message = error?.localizedDescription
                    if message!.contains("There is no user record corresponding to this identifier") {
                        self.showAlert(alertMessage: "This user does not exist. Click 'New User' to create")
                        print(error?.localizedDescription as Any)
                        
                    } else if message!.contains("The password is invalid or the user does not have a password") {
                        self.showAlert(alertMessage: "Password incorrect")
                        
                    } else {
                        print(error?.localizedDescription as Any)
                    }
                    UserDefaults.standard.set("false", forKey: "lastLoginSucceeded")
                } else {
                    print("Login was successful")
                    print("user.login = \(username)")
                    self.loggedIn = true
                    
                    UserDefaults.standard.set("true", forKey: "lastLoginSucceeded")
                    if self.loginTextField.text != "" && self.passwordTextField.text != "" {
                        UserDefaults.standard.set(self.loginTextField.text!, forKey: "user")
                        UserDefaults.standard.set(self.passwordTextField.text!, forKey: "password")
                        print("ViewController: setting password default value to: \(String(describing: UserDefaults.standard.object(forKey: "password") as? String))")
                    }
                }
            }
    }
    
    func showAlert(alertMessage: String) {
        let alert = UIAlertController(title: alertMessage, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true)
    }

}
    


