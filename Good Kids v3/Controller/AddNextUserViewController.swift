//
//  AddNextUserViewController.swift
//  abseil
//
//  Created by Aleksandr Ozhogin on 12/3/20.
//

import UIKit
import Firebase

class AddNextUserViewController: UIViewController {

    var user: User?
//    var db: Firestore!
//    var email: String = ""
//    let defaults = UserDefaults.standard
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func submitButtonPressed(_ sender: Any) {
        if loginTextField.text == "" || passwordTextField.text == "" || nameTextField.text == "" {
            showAlert(alertMessage: "Please fill all fields")
        } else if String(passwordTextField.text!).count < 6 {
            showAlert(alertMessage: "Password should be at least 6 digits lengh")
        } else {
            if let newParentUser = loginTextField.text {
                let email = "\(newParentUser.lowercased())@mydomain.com"
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
                        print("User \(newParentUser) created successfully")
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
                                            let settings = FirestoreSettings()
                                            Firestore.firestore().settings = settings
                                            let db = Firestore.firestore()
                                            
                                            if let family = self.user?.familyName {
                                                if let newName = self.nameTextField.text {
                                                    db.collection("users").document("\(newParentUser)").setData([
                                                       "login": newParentUser,
                                                       "score": -1,
                                                       "name": newName,
                                                       "isAdult": true,
                                                       "familyName": family
                                                   ]) {err in
                                                       if err != nil {
                                                            print("Error writing into the DB")
                                                       } else {
                                                            print("Record has been added to the users db")
                                                            db.collection("families").document("\(family)").updateData([
                                                            "\(newName)": newParentUser
                                                        ]) {err in
                                                                if err != nil {
                                                                    print("Error writing into the DB")
                                                                } else {
                                                                    print("Record has been added to the famliies db")
                                                                }
                                                            }
                                                        }
                                                       }
                                                   }
                                            }
                                            let menuVC = self.navigationController?.viewControllers[1] as! MainMenuViewController
                                            self.navigationController?.popToViewController(menuVC, animated: true)
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
        }
    }
                                
//                                self.db.collection("\(String(self.modelController.user.familyName))").document("\(login)").setData([
//                                    "login": "\(login))",
//                                    "score": -1,
//                                    "name": "\(String(self.nameTextField.text!))",
//                                    "isAdult": "true"
//                                ]) {err in
//                                    if err != nil {
//                                        print("Error writing into the DB")
//                                    } else {
//                                        print("Record has been added to the db")
//                                    }
//                                }
                                                        
                             
//                        }}}
//
//                        print("signing out")
//                        do {
//                            try Auth.auth().signOut()
//                            } catch {print("could not sign out")
//                            }
//                        print("signing back in")
////                        email = "\(self.user.username)@mydomain.com"
//                        print("logging back with email: \(email)")
//                        if let password = UserDefaults.standard.object(forKey: "password") as? String {
//                            Auth.auth().signIn(withEmail: email, password:  password) { (user, error) in
//                                if error != nil {
//                                    print("some fatal fuckup happened when tried to login back after new user creation: \(error)")
//                                } else {print("logged in back successfully")
//
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
              
        print("NewUserVC: password default value is: \(String(describing: UserDefaults.standard.object(forKey: "password") as? String))")
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func showAlert(alertMessage: String) {
         let alert = UIAlertController(title: alertMessage, message: nil, preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
         
         present(alert, animated: true)
     }
}
